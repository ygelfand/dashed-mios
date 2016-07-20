require 'yaml'
module DashedMios
  class Config
    BASE_PATH=File.expand_path(File.join(File.dirname(__FILE__), "../../etc/"))
    def initialize
      setup(:global)
    end
    def setup(attribute, filename=nil)
      filename ||= "#{attribute}.yml"
      path = File.join(BASE_PATH, filename)
      singleton_class.class_eval { attr_reader attribute } unless respond_to? attribute
      instance_variable_set("@#{attribute}", YAML::load(IO.read(path))) if File.exists? path
    end
  end
end
