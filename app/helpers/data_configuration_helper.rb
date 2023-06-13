module DataConfigurationHelper
  def other_type
    DataConfiguration.instance.other_type
  end

  def data_type_humanized
    DataConfiguration.instance.other_type.to_s.humanize.titlecase
  end
end
