@regresion
Feature: Automatizar el backend de Pet Store

  Background:
    * url apiPetStore
    * def jsonCrearMascota = read('classpath:examples/jsonData/crearMascota.json')

  @TEST-1 @happypath @crearMascosta
  Scenario: Verificar la creación de una nueva mascota
    Given path 'pet'
    And request jsonCrearMascota
    When method post
    Then status 200
    # Guardamos el ID para que otros tests puedan 'llamarlo'
    * def idPet = response.id

  @TEST-3 @happypath
  Scenario: Verificar la actualización (Cambio a ID 3)
    Given path 'pet'
    * jsonCrearMascota.id = '3'
    * jsonCrearMascota.name = 'Toby'
    * jsonCrearMascota.status = 'sold'
    And request jsonCrearMascota
    When method put
    Then status 200

  @TEST-7 @happypath
  Scenario: Verificar búsqueda dinámica (Llamada al TEST-1)
    * def resultado = call read('users.feature@crearMascosta')
    Given path 'pet/' + resultado.idPet
    When method get
    Then status 200

  @TEST-6 @happypath
  Scenario: Subir imagen (Usa el ID 3 creado en el TEST-3)
    * def petId = 3
    Given path 'pet', petId, 'uploadImage'
    And multipart file file = { read: 'classpath:examples/imagenes/perrito.jpg', filename: 'perrito.jpg', contentType: 'image/jpeg' }
    When method post
    Then status 200

  @TEST-5 @happypath
  Scenario Outline: Eliminar mascota (AL FINAL PARA NO ROMPER OTROS TESTS)
    Given path 'pet/' + '<idPet>'
    When method delete
    Then status 200

    Examples:
      | idPet |
      | 1     |
      | 3     |