# frozen_string_literal: true

# WorkOrderStateMachine
module WorkOrderStateMachine
  extend ActiveSupport::Concern

  included do
    enum state: %i[started qc library_preparation sequencing completed]
  end

  def to_next_state
    return unless next_state.present? && send("ready_for_#{next_state}?")
    update_state(next_state)
  end

  def to_previous_state
    return unless previous_state.present? && send("ready_for_#{previous_state}?")
    update_state(previous_state)
  end

  def next_state
    WorkOrder.states.key(WorkOrder.states[state] + 1)
  end

  def previous_state
    WorkOrder.states.key(WorkOrder.states[state] - 1)
  end

  def update_state(state)
    ActiveRecord::Base.transaction do
      send("#{state}!")
      update_sequencescape
    end
  end

  def update_sequencescape
    Sequencescape::Api::WorkOrder.update_state(self)
  end

  def assign_state(state)
    assign_attributes(state: WorkOrder.states[state.to_s])
  end

  private

  def ready_for_sequencing?
    sequencing_run.present? && sequencing_run.pending?
  end

  def ready_for_completed?
    sequencing_run.present? && sequencing_run.completed?
  end

  def ready_for_library_preparation?
    library? && flowcells.empty?
  end

  def ready_for_qc?
    !library?
  end

  def ready_for_started?
    !library
  end
end
