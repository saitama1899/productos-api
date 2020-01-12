# Ejercicio 5 https://docs.google.com/presentation/d/1XnLSCXDUnB5SnCatJJaNsSI8VH8BGF6snZynqz9vO8w/edit#slide=id.g6d6a8540c0_0_12

require 'rails_helper'

RSpec.describe 'products API', type: :request do
    # Inicializar test data 
    let!(:products) { create_list(:product, 10) }
    let(:product_id) { products.first.id }

    # GET /products ############################################
    describe 'GET /products' do
        # make HTTP get request before each example
        before { get '/products' }

        it 'returns products' do
            # 'json' es un custom helper para el parse de las respuestas JSON. Es decir, JSON.parse(response.body)
            # No puede venir vacio
            expect(json).not_to be_empty
            # Tiene que devolver 10 productos diferentes
            expect(json.size).to eq(10)
        end

        it 'returns status code 200' do
            # Devuelve un status 200
            expect(response).to have_http_status(200)
        end
    end

    # GET /products/:id ###########################################
    describe 'GET /products/:id' do
        before { get "/products/#{product_id}" }

        context 'when the record exists' do
            it 'returns the product' do
                # No puede venir vacio
                expect(json).not_to be_empty
                # Encontrar un producto que coincida con su ID
                expect(json['id']).to eq(product_id)
            end
            # Devuelve un status 200
            it 'returns status code 200' do
                expect(response).to have_http_status(200)
            end
        end

        context 'when the record does not exist' do
            let(:product_id) { 100 }

            # Tiene que dar un error controlado si el id no existe en DB
            it 'returns status code 404' do
                # Devuelve un status 404
                expect(response).to have_http_status(404)
            end

            it 'returns a not found message' do
                expect(response.body).to match("{\"message\":\"Couldn't find Product with 'id'=100\"}")
            end
        end
    end

    # POST /products ###########################################
    describe 'POST /products' do
        # Definir un payload valido
        let(:valid_attributes) { { name: 'Bollicao', description: 'Es malo', price: 2, stock: 5 } }

        context 'when the request is valid' do
            before { post '/products', params: valid_attributes }

            it 'creates a product' do
                expect(json['name']).to eq('Bollicao')
                expect(json['description']).to eq('Es malo')
                expect(json['price']) == 2
                expect(json['stock']) == 5
            end

            # Comprobar que el post creado coincida con el de BD
            it 'checks creted product is stored' do
                get "/products/#{json['id']}"

                expect(json).to_not be_empty
                expect(json["name"]).to eq('Bollicao')
                expect(json["description"]).to eq('Es malo')
                expect(json["price"]) == 2
                expect(json["stock"]) == 5  
            end
            # Devuelve un status 201
            it 'returns status code 201' do
                expect(response).to have_http_status(201)
            end
         end

        # Tiene que controlar el error si falta un campo/s obligatorio/s
        context 'when the request is invalid' do
            before { post '/products', params: { name: 'Bollicao' } }
            # Devuelve un status 422
            it 'returns status code 422' do
                expect(response).to have_http_status(422)
            end

            it 'returns a validation failure message' do
                expect(response.body)
                .to match("{\"message\":\"Validation failed: Description can't be blank, Price can't be blank, Price is not a number, Stock can't be blank, Stock is not a number\"}")
            end
        end

        # No se puede crear productos con Stock en negativo
        context 'when the stock is negative' do
            before { post '/products', params: { name: 'Bollicao', description: 'Es malo', price: 2, stock: -5 } }

            it 'returns status code 422' do
                expect(response).to have_http_status(422)
            end

            it 'returns a validation failure message' do
                expect(response.body)
                .to match("{\"message\":\"Validation failed: Stock must be greater than or equal to 0\"}")
            end
        end
    end

    # PUT /products/:id ###########################################
    describe 'PUT /products/:id' do
        let(:valid_attributes) { { name: 'Colacao' } }
        let(:invalid_price) { { price: -2 } }

        context 'when the record exists' do
            before { put "/products/#{product_id}", params: valid_attributes }
            
            it 'updates the record' do
                expect(response.body).to be_empty
            end

            # Comprobar que el post editado coincida con el de BD
            it 'checks updated product is stored' do
                get "/products/#{product_id}"

                expect(json).to_not be_empty
                expect(json["name"]).to eq('Colacao')
                # Comprobar que los ID coinciden
                expect(json["id"]).to eq(product_id)
            end

            it 'returns status code 204' do
                expect(response).to have_http_status(204)
            end
        end

        # No se pueden actualizar productos con Precio en negativo
        context 'when the price is negative' do
            before { put "/products/#{product_id}", params: invalid_price }

            it 'returns status code 422' do
                expect(response).to have_http_status(422)
            end

            it 'returns a validation failure message' do
                expect(response.body)
                .to match("{\"message\":\"Validation failed: Price must be greater than or equal to 0\"}")
            end
        end
    end

    # DELETE /products/:id ###########################################
    describe 'DELETE /products/:id' do
        before { delete "/products/#{product_id}" }

        it 'returns status code 204' do
            expect(response).to have_http_status(204)
        end
    end
    
end