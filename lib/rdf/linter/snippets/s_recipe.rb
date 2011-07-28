# data-vocabulary `Person` snippet:
module RDF::Linter
  LINTER_HAML.merge!({
    RDF::URI("http://schema.org/Recipe") => {
      # Properties to be used in snippet title
      :title_props => ["http://schema.org/name"],
      # Post-processing on nested markup
      :title_fmt => lambda {|list, &block| list.map{|e| block.call(e)}.compact.join("- ")},
      # Properties to be used in snippet photo
      :photo_props => ["http://schema.org/image"],
      # Properties to be used in snippet body
      :body_props => [
        "http://schema.org/recipeCategory",
        "http://schema.org/recipeCuisine",
        "http://schema.org/reviews",
        "http://schema.org/cookTime",
      ],
      # Post-processing on nested markup
      :body_fmt => lambda {|list, &block|
        review = block.call("http://schema.org/reviews")
        recipeCategory = block.call("http://schema.org/reviews")
        recipeCuisine = block.call("http://schema.org/reviews")
        cookTime = block.call("http://schema.org/cookTime")
        totalTime = block.call("http://schema.org/totalTime")
        review.to_s +
        recipeCategory.to_s +
        recipeCuisine.to_s +
        (cookTime ? "- Total cook time: #{cookTime}" : "") +
        (totalTime ? "- Total prep/cook time: #{cookTime}" : "")
      },
      :description_props => ["http://schema.org/description", "http://schema.org/recipeInstructions"],
      # Properties to be used when snippet summary nested
      :nested_props => [
        "http://schema.org/name",
      ],
      :property_value => %(
        - if predicate == "http://schema.org/aggregateRating"
          != rating_helper(predicate, object)
        - elsif res = yield(object)
          != res
        - elsif predicate == "http://schema.org/image"
          %span{:rel => rel}
            %img{:src => object.to_s, :alt => ""}
        - elsif object.literal?
          %span{:property => property, :content => get_content(object), :lang => get_lang(object), :datatype => get_dt_curie(object)}= escape_entities(get_value(object))
        - else
          %span{:rel => rel, :resource => get_curie(object)}
      ),
    }
  })
end