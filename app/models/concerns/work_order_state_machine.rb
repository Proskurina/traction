# frozen_string_literal: true

# WorkOrderStateMachine
module WorkOrderStateMachine
  extend ActiveSupport::Concern

  included do
    enum state: %i[started qc library_preparation sequencing completed]
  end

  private


end