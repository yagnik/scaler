module Scaler
  module Ec2
    module Taggable
      def tag(instance, id, type)
        instance.tags[Scaler::Settings.internal.type_tag] = type
        instance.tags[Scaler::Settings.internal.id_tag] = id
      end

      def find(instance, id, type)
        instance
          .tagged(Scaler::Settings.internal.type_tag)
          .tagged_values(type)
          .tagged(Scaler::Settings.internal.id_tag)
          .tagged_values(id).first
      end
    end
  end
end
