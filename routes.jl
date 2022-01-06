using Stipple
using StippleUI
using Genie.Requests, Genie.Renderer, Genie.Router
using Images, Colors, FileIO, Plots,ImageMagick,Base64;

Genie.config.cors_headers["Access-Control-Allow-Origin"] = "*"
Genie.config.cors_headers["Access-Control-Allow-Headers"] = "Content-Type"
Genie.config.cors_headers["Access-Control-Allow-Methods"] = "GET,POST,PUT,DELETE,OPTIONS"
Genie.config.cors_allowed_origins = ["*"]

const FILE_PATH = "public/sample.jpg"
const FINAL_PATH = "final.jpg"
#const IMGPATH = "demo.png"

# CardDemo definition inheriting from ReactiveModel
# Base.@kwdef: that defines keyword based contructor of mutable struct
@reactive mutable struct Model <: ReactiveModel
    process::R{Bool} = false
    imageurl::R{String} = ""
end

model = Model |> init

on(model.process) do _
    model.imageurl[] = ""
    @info "Working"

    img = FileIO.load(FILE_PATH)

    img_gray = Gray.(img)

    @info img_gray
    sobel_image = convert(Array{Float64}, img_gray)
    kernel_x = Array{Float64}([1 0 -1; 2 0 -2; 1 0 -1])
    kernel_y = Array{Float64}([1 2 1; 0 0 0; -1 -2 -1])

    function sobel(img)
        edge_img = zeros(Gray{Float64}, size(img, 1), size(img, 2))
        for x = 1:size(edge_img, 1)-size(kernel_x, 1)
            for y = 1:size(edge_img, 2)-size(kernel_y, 2)
                gx = sum(
                    Gray{
                        Float64,
                    }.(@view img[x:x+size(kernel_x, 1)-1, y:y+size(kernel_y, 2)-1]) .*
                    kernel_x,
                )
                gy = sum(
                    Gray{
                        Float64,
                    }.(@view img[x:x+size(kernel_x, 1)-1, y:y+size(kernel_y, 2)-1]) .*
                    kernel_y,
                )
                edge_img[x+1, y+1] = hypot(gx, gy)
            end
        end
        return edge_img
    end

  
    lastImage = clamp01nan.(sobel(sobel_image))
    #save(FINAL_PATH, lastImage)
    #save(joinpath(@__DIR__, "public", FINAL_PATH), lastImage)
    @info save(joinpath(@__DIR__, "public", FINAL_PATH), lastImage)
   
    model.imageurl[] = "/$FINAL_PATH#$(Base.time())"
    @info model.imageurl[]
    if (model.process[])
        model.process[] = false
        #model.imageurl[] = ""
    end
        
end



function ui(model)
    [
        page( model,
            class = "container",
            title = "Card Demo",
            partial = true,
            [
                row( # row takes a tuple of cells. Creates a `div` HTML element with a CSS class named `row`.
                    cell([h1("Edge Detection Project")]),
                )
                row(
                    [
                        cell([
                            h2("Initial Image"),
                            card(
                                class = "text-primary d-flex justify-content-start",
                                Html.div(
                                    class = "col-md-12",
                                    [
                                        uploader(
                                            label = "Upload Image",
                                            :auto__upload,
                                            :multiple,
                                            method = "POST",
                                            url = "http://localhost:8000/upload",
                                            field__name = "img",
                                        ),
                                    ],
                                ),
                            ),
                            btn("Process Image!", @click("process = true")),
                        ])
                        cell([
                            h2("Transformed Image"),
                            card(
                                class = "text-primary d-flex justify-content-end",
                                quasar(:img, src=:imageurl, spinner__color="white", style="height: 140px; max-width: 150px")
                                #imageview(src=:imageurl, spinner__color="white", style="height: 250px; max-width: 250px")
                            ),
                        ])
                    ],
                )
            ],
        ),
    ]
end

route("/") do
    html(ui(model), context = @__MODULE__)
end


route("/upload", method = POST) do
    if infilespayload(:img)
        @info Requests.filename(filespayload(:img))
        
        open(FILE_PATH, "w") do io
            write(FILE_PATH, filespayload(:img).data)
        @info File
        end
    else
        @info "No image uploaded"
       
    end 
    Genie.Renderer.redirect(:get)
end

#isrunning(:webserver) || up()
