class ClasicoLlano {
  final String artista;
  final String apodo;
  final String estado;
  final String pais;
  final List<CancionClasica> canciones;
  final String imagen;

  const ClasicoLlano({
    required this.artista,
    required this.apodo,
    required this.estado,
    required this.pais,
    required this.canciones,
    required this.imagen,
  });
}

class CancionClasica {
  final String titulo;
  final String audio;

  const CancionClasica({
    required this.titulo,
    required this.audio,
  });
}

final List<ClasicoLlano> clasicosLlano = [

  ClasicoLlano(
    artista: "Santiago Rojas",
    apodo: "El Turpial de Guardatinajas",
    estado: "Guárico",
    pais: "Venezuela",
    imagen: "assets/images/clasicos/Santiago_Rojas.png",
    canciones: [
      CancionClasica(
        titulo: "La Viuda Millonaria",
        audio: "assets/audio/clasicos/santiago_rojas/la_viuda_millonaria.mp3",
      ),
      CancionClasica(
        titulo: "Cuando Me Robé El Cochino",
        audio: "assets/audio/clasicos/santiago_rojas/cuando_me_robe_el_cochino.mp3",
      ),
    ],
  ),

  ClasicoLlano(
    artista: "Jesús Moreno",
    apodo: "El Rey del Pasaje",
    estado: "Apure",
    pais: "Venezuela",
    imagen: "assets/images/clasicos/Jesus_Moreno.png",
    canciones: [
      CancionClasica(
        titulo: "Amiga, Novia y Amante",
        audio: "assets/audio/clasicos/jesus_moreno/amiga_novia_y_amante.mp3",
      ),
      CancionClasica(
        titulo: "Que Te Perdone El Diablo",
        audio: "assets/audio/clasicos/jesus_moreno/que_te_perdone_el_diablo.mp3",
      ),
    ],
  ),

  ClasicoLlano(
    artista: "Francisco Montoya",
    apodo: "El Tigre de Payara",
    estado: "Apure",
    pais: "Venezuela",
    imagen: "assets/images/clasicos/Francisco Montoya.png",
    canciones: [
      CancionClasica(
        titulo: "Apure en un Viaje",
        audio: "assets/audio/clasicos/francisco_montoya/apure_en_un_viaje.mp3",
      ),
      CancionClasica(
        titulo: "Sentimiento Apureño",
        audio: "assets/audio/clasicos/francisco_montoya/sentimiento_apureno.mp3",
      ),
    ],
  ),

  ClasicoLlano(
    artista: "Eneas Perdomo",
    apodo: "El General del Pasaje",
    estado: "Apure",
    pais: "Venezuela",
    imagen: "assets/images/clasicos/Eneas_Perdomo.png",
    canciones: [
      CancionClasica(
        titulo: "Fiesta en Elorza",
        audio: "assets/audio/clasicos/eneas_perdomo/fiesta_en_elorza.mp3",
      ),
      CancionClasica(
        titulo: "Adiós Barrancas de Arauca",
        audio: "assets/audio/clasicos/eneas_perdomo/adios_barrancas_de_arauca.mp3",
      ),
    ],
  ),

  ClasicoLlano(
    artista: "Teo Galíndez",
    apodo: "El Ruiseñor de Venezuela",
    estado: "Cojedes",
    pais: "Venezuela",
    imagen: "assets/images/clasicos/Teo_Galindez.png",
    canciones: [
      CancionClasica(
        titulo: "Para Toda La Vida",
        audio: "assets/audio/clasicos/teo_galindez/para_toda_la_vida.mp3",
      ),
      CancionClasica(
        titulo: "Dos Mujeres En Mi Vida",
        audio: "assets/audio/clasicos/teo_galindez/dos_mujeres_en_mi_vida.mp3",
      ),
    ],
  ),
  ClasicoLlano(
    artista: "Ángel Custodio Loyola",
    apodo: "El Primer Cantor del Llano",
    estado: "Guárico",
    pais: "Venezuela",
    imagen: "assets/images/clasicos/Angel_Custodio_Loyola.png",
    canciones: [
      CancionClasica(
        titulo: "El Gavilán",
        audio: "assets/audio/clasicos/angel_custodio_loyola/el_gavilan.mp3",
      ),
      CancionClasica(
        titulo: "Cajón de Arauca Apureño",
        audio: "assets/audio/clasicos/angel_custodio_loyola/cajon_de_arauca_apureno.mp3",
      ),
    ],
  ),

  ClasicoLlano(
    artista: "Juan de los Santos Contreras",
    apodo: "El Carrao de Palmarito",
    estado: "Apure",
    pais: "Venezuela",
    imagen: "assets/images/clasicos/Juan_De_Los_Santos.png",
    canciones: [
      CancionClasica(
        titulo: "Llanura, Yo Soy Tu Hijo",
        audio: "assets/audio/clasicos/el_carrao_de_palmarito/llanura_yo_soy_tu_hijo.mp3",
      ),
      CancionClasica(
        titulo: "Furia",
        audio: "assets/audio/clasicos/el_carrao_de_palmarito/furia.mp3",
      ),
    ],
  ),

  ClasicoLlano(
    artista: "Luis Lozada",
    apodo: "El Cubiro",
    estado: "Barinas",
    pais: "Venezuela",
    imagen: "assets/images/clasicos/Luis Lozada.png",
    canciones: [
      CancionClasica(
        titulo: "La Boda del Gabán",
        audio: "assets/audio/clasicos/luis_lozada/la_boda_del_gaban.mp3",
      ),
      CancionClasica(
        titulo: "El Hijo de Florentino",
        audio: "assets/audio/clasicos/luis_lozada/el_hijo_de_florentino.mp3",
      ),
    ],
  ),

  ClasicoLlano(
    artista: "Cheo Hernández Prisco",
    apodo: "El Coplero Coleador",
    estado: "Portuguesa",
    pais: "Venezuela",
    imagen: "assets/images/clasicos/Cheo_Hernandez_Prisco.png",
    canciones: [
      CancionClasica(
        titulo: "A Quién No Le Va a Gustar",
        audio: "assets/audio/clasicos/cheo_hernandez_prisco/a_quien_no_le_va_a_gustar.mp3",
      ),
      CancionClasica(
        titulo: "Sin Ella No Vivo",
        audio: "assets/audio/clasicos/cheo_hernandez_prisco/sin_ella_no_vivo.mp3",
      ),
    ],
  ),

  ClasicoLlano(
    artista: "Juan Farfán",
    apodo: "El Coplero Sentimental",
    estado: "Arauca",
    pais: "Colombia",
    imagen: "assets/images/clasicos/Juan_Farfan.png",
    canciones: [
      CancionClasica(
        titulo: "La Camisa Conuquera",
        audio: "assets/audio/clasicos/juan_farfan/la_camisa_conuquera.mp3",
      ),
      CancionClasica(
        titulo: "Maté el Guayabo",
        audio: "assets/audio/clasicos/juan_farfan/mate_el_guayabo.mp3",
      ),
    ],
  ),

  ClasicoLlano(
    artista: "Reyna Lucero",
    apodo: "La Reina de la Canción Criolla",
    estado: "Aragua",
    pais: "Venezuela",
    imagen: "assets/images/clasicos/Reina_Lucero.png",
    canciones: [
      CancionClasica(
        titulo: "Carrao Carrao",
        audio: "assets/audio/clasicos/reyna_lucero/carrao_carrao.mp3",
      ),
      CancionClasica(
        titulo: "Son Mentiras",
        audio: "assets/audio/clasicos/reyna_lucero/son_mentiras.mp3",
      ),
    ],
  ),

  ClasicoLlano(
    artista: "Cristina Maica",
    apodo: "La Vecina",
    estado: "Apure",
    pais: "Venezuela",
    imagen: "assets/images/clasicos/La Vecina_20260709_102854_0000.png",
    canciones: [
      CancionClasica(
        titulo: "La Vecina",
        audio: "assets/audio/clasicos/cristina_maica/la_vecina.mp3",
      ),
      CancionClasica(
        titulo: "Soy Apureña de Raza",
        audio: "assets/audio/clasicos/cristina_maica/soy_apurena_de_raza.mp3",
      ),
    ],
  ),

  ClasicoLlano(
    artista: "Elisa Guerrero",
    apodo: "La Veguera",
    estado: "Barinas",
    pais: "Venezuela",
    imagen: "assets/images/clasicos/Elisa_Guerrero.png",
    canciones: [
      CancionClasica(
        titulo: "Un Guayabo Motolito",
        audio: "assets/audio/clasicos/elisa_guerrero/un_guayabo_motolito.mp3",
      ),
      CancionClasica(
        titulo: "Juro Que Te Gusto",
        audio: "assets/audio/clasicos/elisa_guerrero/juro_que_te_gusto.mp3",
      ),
    ],
  ),

  ClasicoLlano(
    artista: "Reynaldo Armas",
    apodo: "El Cardenal Sabanero",
    estado: "Guárico",
    pais: "Venezuela",
    imagen: "assets/images/clasicos/Reynaldo_Armas.png",
    canciones: [
      CancionClasica(
        titulo: "A Usted",
        audio: "assets/audio/clasicos/reynaldo_armas/a_usted.mp3",
      ),
      CancionClasica(
        titulo: "Laguna Vieja",
        audio: "assets/audio/clasicos/reynaldo_armas/laguna_vieja.mp3",
      ),
    ],
  ),

  ClasicoLlano(
    artista: "Jorge Guerrero",
    apodo: "El Guerrero del Folklore",
    estado: "Apure",
    pais: "Venezuela",
    imagen: "assets/images/clasicos/Jorge_Guerrero.png",
    canciones: [
      CancionClasica(
        titulo: "Añoranzas",
        audio: "assets/audio/clasicos/jorge_guerrero/anoranzas.mp3",
      ),
      CancionClasica(
        titulo: "Guayabo de Mes y Pico",
        audio: "assets/audio/clasicos/jorge_guerrero/guayabo_de_mes_y_pico.mp3",
      ),
    ],
  ),
];
