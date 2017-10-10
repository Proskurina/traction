# frozen_string_literal: true

# WorkOrder
class WorkOrder < ApplicationRecord
  include WorkOrderStateMachine

  belongs_to :aliquot
  has_one :library
  has_many :events
  has_many :flowcells, inverse_of: :work_order
  # should have only one
  has_many :sequencing_runs, through: :flowcells

  attr_readonly :sequencescape_id, :library_preparation_type, :data_type,
                :number_of_flowcells, :study_uuid, :sample_uuid

  validates_presence_of :sequencescape_id, :library_preparation_type,
                        :data_type, :number_of_flowcells,
                        :study_uuid, :sample_uuid

  # validate :maximum_number_of_flowcells

  accepts_nested_attributes_for :aliquot, :library

  delegate :name, :tube_barcode, :source_plate_barcode,
           :source_well_position, :short_source_plate_barcode, to: :aliquot

  scope :by_state, (->(state) { where(state: WorkOrder.states[state.to_s]) })
  scope :by_date, (-> { order(created_at: :desc) })

  before_save :add_event

  def library?
    library.present?
  end

  def editable?
    started? || qc?
  end

  def sequencing_run
    sequencing_runs.first
  end

  private

  def add_event
    events.build(state_from: 'none', state_to: state) if new_record?
    events.build(state_from: state_was, state_to: state) if state_changed?
  end

  # def maximum_number_of_flowcells
  #   return unless number_of_flowcells.present?
  #   return unless flowcells.length > number_of_flowcells
  #   errors.add(:flowcells, "number must not exceed #{number_of_flowcells}")
  # end
end
