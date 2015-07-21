@compat function barplot(;x::AbstractVector = Int[],
                  y::AbstractVector = Int[],
                  y2::AbstractVector = Int[],
                  group::AbstractVector = Int[],
                  stacked::Bool = false,
                  horizontal::Bool = false)

    v = VegaVisualization()

    default_scales!(v)
    v.scales[1]._type = "ordinal"
    default_axes!(v)
    default_legend!(v)

    add_data!(v, x = x, y = y, group = group, y2 = y2)
    add_rects!(v)

    v.marks[1].properties.enter.width = VegaValueRef(scale = "x", band = true, offset = -1)
    v.marks[1].properties.enter.y = VegaValueRef(scale = "y", field = "y")
    v.marks[1].properties.enter.y2 = VegaValueRef(scale = "y", field = "y2")
    v.marks[1].properties.enter.fill = VegaValueRef(scale = "group", field = "group")

    if stacked
      push!(v.data, VegaData(name = "stats", source = "table",
                             transform = [VegaTransform(Dict{Any, Any}("type"=> "aggregate", "groupby" => ["x"], "summarize"=>[Dict{Any,Any}("field" => "y", "ops" => ["sum"])]))]))

      # bind the y scale to layout start and layout end
      v.marks[1].properties.enter.y = VegaValueRef(scale = "y", field = "layout_start")
      v.marks[1].properties.enter.y2 = VegaValueRef(scale = "y", field = "layout_end")

      v.scales[2].domain = VegaDataRef("stats", "sum_y")

      v.marks[1].from = Dict{Any, Any}("data" => "table",
                                       "transform" => [VegaTransform(Dict{Any, Any}("type" => "stack", "groupby" => ["x"], "sortby" => ["group"], "field"=>"y"))])
    end

    #Return horizontal bar chart
    if horizontal
        coord_flip!(v)
    end

    return v
end
