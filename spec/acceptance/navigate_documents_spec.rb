# encoding: utf-8

require 'spec_helper'

describe "Navigating included documents" do
  
  example "Accesing included data" do
    stub_auth_request(:get, "http://movida.example.com/people/1").to_return(body: %q{
      <person>
        <name>Pedro Almodóvar</name>
        <extra-data type="document">
          <biography>
            <birthplace>Calzada de Calatrava</birthplace>
            <birthyear type="integer">1949</birthyear>
            <films type="array">
              <film>
                <title>¿Qué he hecho yo para merecer esto?</title>
                <year type="integer">1984</year>
              </film>
              <film>
                <title>Mujeres al borde de un ataque de nervios</title>
                <year type="integer">1988</year>
              </film>
            </films>
          </biography>
          <oscars type="array">
            <oscar>
              <year type="integer">1999</year>
              <film>Todo sobre mi madre</film>
            </oscar>
            <oscar>
              <year type="integer">2002</year>
              <film>Hable con ella</film>
            </oscar>
          </oscars>
        </extra-data>
      </person>
    })
  
    person = Almodovar::Resource("http://movida.example.com/people/1", auth)
    
    expect(person).to respond_to(:extra_data)
    
    expect(person.name).to eq("Pedro Almodóvar")
    expect(person.extra_data["biography"]["birthplace"]).to eq("Calzada de Calatrava")
    expect(person.extra_data["biography"]["birthyear"]).to eq(1949)
    expect(person.extra_data["biography"]["films"][0]["title"]).to eq("¿Qué he hecho yo para merecer esto?")
    expect(person.extra_data["biography"]["films"][0]["year"]).to eq(1984)
    expect(person.extra_data["biography"]["films"][1]["title"]).to eq("Mujeres al borde de un ataque de nervios")
    expect(person.extra_data["biography"]["films"][1]["year"]).to eq(1988)
    expect(person.extra_data["oscars"][0]["year"]).to eq(1999)
    expect(person.extra_data["oscars"][0]["film"]).to eq("Todo sobre mi madre")
    expect(person.extra_data["oscars"][1]["year"]).to eq(2002)
    expect(person.extra_data["oscars"][1]["film"]).to eq("Hable con ella")
    
  end
  
  example "Accessing document resources" do
    stub_auth_request(:get, "http://movida.example.com/people/1/biography").to_return(body: %q{
      <biography type="document">
        <birthplace>Calzada de Calatrava</birthplace>
        <birthyear type="integer">1949</birthyear>
        <films type="array">
          <film>
            <title>¿Qué he hecho yo para merecer esto?</title>
            <year type="integer">1984</year>
          </film>
          <film>
            <title>Mujeres al borde de un ataque de nervios</title>
            <year type="integer">1988</year>
          </film>
        </films>
      </biography>
    })
  
    bio = Almodovar::Resource("http://movida.example.com/people/1/biography", auth)
    
    expect(bio["birthplace"]).to eq("Calzada de Calatrava")
    expect(bio["birthyear"]).to eq(1949)
    expect(bio["films"][0]["title"]).to eq("¿Qué he hecho yo para merecer esto?")
    expect(bio["films"][0]["year"]).to eq(1984)
    expect(bio["films"][1]["title"]).to eq("Mujeres al borde de un ataque de nervios")
    expect(bio["films"][1]["year"]).to eq(1988)
  end
  
end