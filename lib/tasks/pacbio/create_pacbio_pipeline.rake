# frozen_string_literal: true

# rubocop:disable all
namespace :pacbio do
  desc 'Create pacbio pipeline'
  task create: :environment do
    pipeline = Pipeline.create!(name: 'pacbio', flexible: true)
    Requirement.create!(name: 'insert_size', pipeline: pipeline)
    Requirement.create!(name: 'sequencing_type', pipeline: pipeline)
    Requirement.create!(name: 'lanes_of_sequencing_required', pipeline: pipeline)
    Requirement.create!(name: 'amount_of_data_required', pipeline: pipeline)

    ProcessStep.create!(name: 'reception',  pipeline: pipeline, position: 1, visible: false)

    # DNA QC step
    dna_qc = ProcessStep.create!(name: 'dna_qc',  pipeline: pipeline, position: 2)
    MetadataField.create!(name: 'concentration_in_ng/microliter',
                          required: true,
                          process_step: dna_qc,
                          data_type: :integer)
    MetadataField.create!(name: 'fragment_size_in_base_pairs',
                          required: true,
                          process_step: dna_qc,
                          data_type: :integer)
    fragment_size_instrument = MetadataField.create!(name: 'fragment_size_instrument',
                                    required: true,
                                    process_step: dna_qc,
                                    data_type: :options)
    Option.create!(name: 'FEMTO_Pulse', metadata_field: fragment_size_instrument)
    Option.create!(name: 'tape_station', metadata_field: fragment_size_instrument)
    MetadataField.create!(name: 'volume_in_microlitres',
                          required: false,
                          process_step: dna_qc,
                          data_type: :integer)
    state = MetadataField.create!(name: 'state',
                                    required: true,
                                    process_step: dna_qc,
                                    data_type: :options)
    Option.create!(name: 'proceed', metadata_field: state)
    Option.create!(name: 'failed', metadata_field: state)
    MetadataField.create!(name: 'comment',
                          required: false,
                          process_step: dna_qc,
                          data_type: :string)

    # Shearing and qc step

    shearing = ProcessStep.create!(name: 'shearing_and_qc',  pipeline: pipeline, position: 3, visible: false)
    MetadataField.create!(name: 'number_of_passes',
                          required: true,
                          process_step: shearing,
                          data_type: :integer)
    MetadataField.create!(name: 'number_of_runs',
                          required: true,
                          process_step: shearing,
                          data_type: :integer)
    MetadataField.create!(name: 'concentration_in_ng/microliter',
                          required: true,
                          process_step: shearing,
                          data_type: :integer)
    MetadataField.create!(name: 'fragment_size_in_base_pairs',
                          required: true,
                          process_step: shearing,
                          data_type: :integer)
    fragment_size_instrument = MetadataField.create!(name: 'fragment_size_instrument',
                                    required: true,
                                    process_step: shearing,
                                    data_type: :options)
    Option.create!(name: 'FEMTO_Pulse', metadata_field: fragment_size_instrument)
    Option.create!(name: 'tape_station', metadata_field: fragment_size_instrument)
    state = MetadataField.create!(name: 'state',
                                    required: true,
                                    process_step: shearing,
                                    data_type: :options)
    Option.create!(name: 'proceed', metadata_field: state)
    Option.create!(name: 'failed', metadata_field: state)
    MetadataField.create!(name: 'comment',
                          required: false,
                          process_step: shearing,
                          data_type: :string)

    # Sheared DNA clean up and QC
    clean_up = ProcessStep.create!(name: 'sheared_dna_clean_up_and_qc',  pipeline: pipeline, position: 4, visible: false)
    MetadataField.create!(name: 'volume_in_microlitres',
                          required: true,
                          process_step: clean_up,
                          data_type: :integer)
    MetadataField.create!(name: 'concentration_in_ng/microliter',
                          required: true,
                          process_step: clean_up,
                          data_type: :integer)
    MetadataField.create!(name: 'DNA_quality_field_260/280',
                          required: true,
                          process_step: clean_up,
                          data_type: :integer)
    MetadataField.create!(name: 'DNA_quality_field_260/230',
                          required: true,
                          process_step: clean_up,
                          data_type: :integer)
    MetadataField.create!(name: 'total_amount_of_DNA',
                          required: true,
                          process_step: clean_up,
                          data_type: :integer)
    state = MetadataField.create!(name: 'state',
                                    required: true,
                                    process_step: clean_up,
                                    data_type: :options)
    Option.create!(name: 'proceed', metadata_field: state)
    Option.create!(name: 'failed', metadata_field: state)
    MetadataField.create!(name: 'comment',
                          required: false,
                          process_step: clean_up,
                          data_type: :string)

    # Library creation
    library_creation = ProcessStep.create!(name: 'library_creation_and_make_SMRT_bells', pipeline: pipeline, position: 5)
    MetadataField.create!(name: 'library_kit_barcode',
                          required: true,
                          process_step: library_creation,
                          data_type: :string)
    state = MetadataField.create!(name: 'state',
                                    required: true,
                                    process_step: library_creation,
                                    data_type: :options)
    Option.create!(name: 'proceed', metadata_field: state)
    Option.create!(name: 'failed', metadata_field: state)
    MetadataField.create!(name: 'comment',
                          required: false,
                          process_step: library_creation,
                          data_type: :string)

    #SMRT bell qc
    smrt_bell_qc = ProcessStep.create!(name: 'SMRT_bell_qc',  pipeline: pipeline, position: 6)
    MetadataField.create!(name: 'concentration_in_ng/microliter',
                          required: true,
                          process_step: smrt_bell_qc,
                          data_type: :integer)
    MetadataField.create!(name: 'fragment_size_in_base_pairs',
                          required: true,
                          process_step: smrt_bell_qc,
                          data_type: :integer)
    fragment_size_instrument = MetadataField.create!(name: 'fragment_size_instrument',
                                    required: true,
                                    process_step: smrt_bell_qc,
                                    data_type: :options)
    Option.create!(name: 'FEMTO_Pulse', metadata_field: fragment_size_instrument)
    Option.create!(name: 'tape_station', metadata_field: fragment_size_instrument)
    MetadataField.create!(name: 'volume_in_microlitres',
                          required: true,
                          process_step: smrt_bell_qc,
                          data_type: :integer)
    state = MetadataField.create!(name: 'state',
                                    required: true,
                                    process_step: smrt_bell_qc,
                                    data_type: :options)
    Option.create!(name: 'proceed', metadata_field: state)
    Option.create!(name: 'failed', metadata_field: state)
    MetadataField.create!(name: 'comment',
                          required: false,
                          process_step: smrt_bell_qc,
                          data_type: :string)

    # Blue Pippin size selection and SS SMRT Bells clean up
    blue_pippin = ProcessStep.create!(name: 'blue_pippin_and_SS_SMRT_bells_clean_up', pipeline: pipeline, position: 7, visible: false)
    MetadataField.create!(name: 'total_DNA_in_nanograms',
                          required: true,
                          process_step: blue_pippin,
                          data_type: :string)
    MetadataField.create!(name: 'cut_size_in_base_pairs',
                          required: true,
                          process_step: blue_pippin,
                          data_type: :string)
    state = MetadataField.create!(name: 'state',
                                    required: true,
                                    process_step: blue_pippin,
                                    data_type: :options)
    Option.create!(name: 'proceed', metadata_field: state)
    Option.create!(name: 'failed', metadata_field: state)
    MetadataField.create!(name: 'comment',
                          required: false,
                          process_step: blue_pippin,
                          data_type: :string)

    # Damage repair and qc

    damage_repair = ProcessStep.create!(name: 'damage_repair_and_qc',  pipeline: pipeline, position: 8, visible: false)
    MetadataField.create!(name: 'concentration_in_ng/microliter',
                          required: true,
                          process_step: damage_repair,
                          data_type: :integer)
    MetadataField.create!(name: 'fragment_size_in_base_pairs',
                          required: true,
                          process_step: damage_repair,
                          data_type: :integer)
    fragment_size_instrument = MetadataField.create!(name: 'fragment_size_instrument',
                                    required: true,
                                    process_step: damage_repair,
                                    data_type: :options)
    Option.create!(name: 'FEMTO_Pulse', metadata_field: fragment_size_instrument)
    Option.create!(name: 'tape_station', metadata_field: fragment_size_instrument)
    MetadataField.create!(name: 'volume_in_microlitres',
                          required: true,
                          process_step: damage_repair,
                          data_type: :integer)
    state = MetadataField.create!(name: 'state',
                                    required: true,
                                    process_step: damage_repair,
                                    data_type: :options)
    Option.create!(name: 'proceed', metadata_field: state)
    Option.create!(name: 'failed', metadata_field: state)
    MetadataField.create!(name: 'comment',
                          required: false,
                          process_step: damage_repair,
                          data_type: :string)

    ProcessStep.create!(name: 'ready_for_sequencing', pipeline: pipeline, position: 9, visible: true)
    ProcessStep.create!(name: 'sequencing', pipeline: pipeline, position: 10, visible: false)
  end
end
# rubocop:enable all