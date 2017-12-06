# frozen_string_literal: true

unless Rails.env.production?
  require 'factory_girl'

  namespace :pacbio_work_orders do
    desc 'create some work orders'
    task create: :environment do |_t|
      pipeline = Pipeline.find_by(name: 'pacbio')
      10.times do |i|
        aliquot = Aliquot.new(name: "DN4914#{i+1}A:A#{i+1}")
        WorkOrder.create!(aliquot: aliquot,
                  sequencescape_id: i+1,
                  work_order_requirements_attributes: build_work_order_requirements(pipeline),
                  sample_uuid: i+1,
                  study_uuid: i+1)
        receptacle = Receptacle.new
        # TODO: create(destroy) lab events from one place
        LabEvent.create!(aliquot: aliquot,
                         receptacle: receptacle,
                         date: DateTime.now,
                         state: 'transferred')
        LabEvent.create!(aliquot: aliquot,
                         receptacle: receptacle,
                         date: DateTime.now,
                         state: 'process_started',
                         process_step: pipeline.next_process_step)
      end
    end
  end

  def build_work_order_requirements(pipeline)
    [].tap do |attributes_list|
      pipeline.requirements.each_with_index do |requirement, i|
        attributes_list << { requirement_id: requirement.id, value: "Value_#{i}" }
      end
    end
  end
end