# frozen_string_literal: true

# Lab Event - anything that happens with aliquot in a lab
class LabEvent < ApplicationRecord
  belongs_to :receptacle
  belongs_to :aliquot
  belongs_to :process_step, optional: true
  has_many :metadata_items

  enum state: %i[process_started transferred]

  scope :with_process_steps, (-> { where.not(process_step_id: nil) })

  def self.last_process_step
    lab_event = with_process_steps.last
    lab_event.process_step if lab_event.present?
  end

  def metadata
    @metadata ||= (metadata_items.with_metadata_fields.collect(&:to_h).inject(:merge!) || {})
  end

  def name
    process_step.name if process_step.present?
  end
end
