# ability to transform from snake_case (ruby) to CamelCase (.Net)
# maybe there is an IronRuby built-in we could rely on for that ?
module Classifier
  def classify(string)
    string.gsub(/(^|_)(.)/) { $2.upcase } # simplified version of Rails inflector
  end
end