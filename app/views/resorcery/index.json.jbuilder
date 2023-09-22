json.ignore_nil! true
json.set! @resources.model_name.plural do
  json.array! @resources do |resource|
    json.extract! resource, *resource_list_keys
    json.url polymorphic_path(resource, format: :json) rescue nil
  end
end
json.partial! "resorcery/pagination", resources: @resources
