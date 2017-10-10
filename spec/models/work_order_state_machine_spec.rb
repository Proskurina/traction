# frozen_string_literal: true

require 'rails_helper'

RSpec.describe WorkOrder, type: :model do
  include SequencescapeWebmockStubs

  before(:each) do
    stub_updates
  end

  it 'can be moved to next state' do
    work_order = build(:work_order)
    expect(work_order).to be_started

    work_order.to_next_state
    expect(work_order).to be_qc

    work_order.to_next_state
    expect(work_order).to be_qc
    work_order.library = create(:library)
    work_order.to_next_state
    expect(work_order).to be_library_preparation

    work_order.to_next_state
    expect(work_order).to be_library_preparation
    create :flowcell, work_order: work_order
    work_order.to_next_state
    expect(work_order).to be_sequencing

    work_order.to_next_state
    expect(work_order).to be_sequencing
    work_order.sequencing_run.completed!
    work_order.to_next_state
    expect(work_order).to be_completed

    work_order.to_next_state
    expect(work_order).to be_completed
  end

  it 'can be moved to previous state' do
    work_order = build(:work_order)
    work_order.library = create(:library)
    flowcell = create :flowcell, work_order: work_order
    work_order.completed!

    work_order.to_previous_state
    expect(work_order).to be_sequencing

    work_order.to_previous_state
    expect(work_order).to be_sequencing

    new_work_order = create(:work_order)
    flowcell.update_attributes(work_order: new_work_order)

    work_order.to_previous_state
    expect(work_order).to be_library_preparation

    work_order.to_previous_state
    expect(work_order).to be_library_preparation

    work_order.library.destroy
    work_order.reload

    work_order.to_previous_state
    expect(work_order).to be_qc

    work_order.to_previous_state
    expect(work_order).to be_started

    work_order.to_previous_state
    expect(work_order).to be_started
  end
end
