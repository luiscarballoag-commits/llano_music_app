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
        titulo: "Cuando Me Robé El Cochino",
        audio: "assets/audio/clasicos/02_Santiago_Rojas_El_Turpial_de_Guardatinajas_Cuando_Me_Robe_el.mp3",
      ),
      CancionClasica(
        titulo: "El Juego del Araguato",
        audio: "https://drive.google.com/uc?export=download&id=11bwWciy-iuBK4oQ5HTtrYZfPIc5jL9Qy",
      ),
      CancionClasica(
        titulo: "La Culebra Bejuca",
        audio: "https://drive.google.com/uc?export=download&id=1QtYUAxcJ2eAiyrvNk3Wxk471GADM8c3h",
      ),
      CancionClasica(
        titulo: "La Tuerta Carmen Dolores",
        audio: "https://drive.google.com/uc?export=download&id=1tSo7u8CRXh-ifeuvezG7X0qzcTM09-6T",
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
        titulo: "Que Te Perdone El Diablo",
        audio: "assets/audio/clasicos/03_Jesus_Moreno,_Miguel_Tovar,_Saverio_Graterol,_Miguel_Tovar,_Saverio.mp3",
      ),
      CancionClasica(
        titulo: "Punto Final",
        audio: "https://drive.google.com/uc?export=download&id=1XxKjTlrafx9Cs27YD3EzEmzDwyseZLtS",
      ),
      CancionClasica(
        titulo: "Ámame Siempre",
        audio: "https://drive.google.com/uc?export=download&id=1XBuQrinj7QXfxURSiytQFOhDkMK_iN9f",
      ),
      CancionClasica(
        titulo: "Seamos Sinceros",
        audio: "https://drive.google.com/uc?export=download&id=1E6JUOlLDrPWUMF-kZ0rR0fXOaI_q96xx",
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
        titulo: "La Tristeza del Corral",
        audio: "https://drive.google.com/uc?export=download&id=1w4Q7-vjCQzcuRBYhnPfmiytTFRwAWCN3",
      ),
      CancionClasica(
        titulo: "Brisas De Achaguas",
        audio: "https://drive.google.com/uc?export=download&id=1xDVAUY9Zp3RAvHWRv6dUNnvcq46qixJ4",
      ),
      CancionClasica(
        titulo: "Cucarachero Araucano",
        audio: "https://drive.google.com/uc?export=download&id=1Nw2RE-LnGTmpnoEwHys0_Cxpr1w0Cuul",
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
        audio: "assets/audio/clasicos/07_Eneas Perdomo_Fiesta en Elorza.mp3",
      ),
      CancionClasica(
        titulo: "Adiós Barrancas de Arauca",
        audio: "https://drive.google.com/uc?export=download&id=1lSR6nGOteKrYDRtWXqK3gZznA_Fo6Aeq",
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
        audio: "https://drive.google.com/uc?export=download&id=1-tOdWZxV-j21-SyuG35q3DNVWwSc31VV",
      ),
      CancionClasica(
        titulo: "Dos Mujeres En Mi Vida",
        audio: "assets/audio/clasicos/09_Teo Galindez_Dos Mujeres en Mi Vida.mp3",
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
        audio: "assets/audio/clasicos/El Gavilan_Angel_Custodio_Loyola.mp3",
      ),
      CancionClasica(
        titulo: "Cajón de Arauca Apureño",
        audio: "https://drive.google.com/uc?export=download&id=1UTrFLqdSAjSJfBBYBFyL3ZykR79m05ay",
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
        titulo: "Llanura Yo Soy Tu Hijo",
        audio: "assets/audio/clasicos/el_carrao_de_palmarito/llanura_yo_soy_tu_hijo.mp3",
      ),
      CancionClasica(
        titulo: "Furia",
        audio: "https://drive.google.com/uc?export=download&id=1RDFQ_zZkF4zFlMy7FSB5mHzyBMrZdaxO",
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
        titulo: "Malaya un Camino Largo",
        audio: "https://drive.google.com/uc?export=download&id=1dlp6cAzb500Od3kioqaDbA4jyf2ZXWIX",
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
        audio: "assets/audio/clasicos/18_Cheo Hernandez Prisco - A Quien No Le Va a Gustar.mp3",
      ),
      CancionClasica(
        titulo: "Sin Ella No Vivo",
        audio: "https://drive.google.com/uc?export=download&id=1Dc_IpTVkUbZf2IexF6Uiue7mfWoQJzgk",
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
        audio: "https://drive.google.com/uc?export=download&id=1iCaoX2hmH1571qLc56SsAf2PQPAFI5NI",
      ),
      CancionClasica(
        titulo: "Maté el Guayabo",
        audio: "assets/audio/clasicos/19 Mate el Guayabo - Juan Farfán.mp3",
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
        audio: "https://drive.google.com/uc?export=download&id=1YvJVd9INGdcTbQ0QhgJtk9aAetwbzNpu",
      ),
      CancionClasica(
        titulo: "Son Mentiras",
        audio: "assets/audio/clasicos/21- Reyna Lucero - Son Mentiras.mp3",
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
        audio: "assets/audio/clasicos/21 Cristina Maica - La Vecina.mp3",
      ),
      CancionClasica(
        titulo: "Soy Apureña de Raza",
        audio: "https://drive.google.com/uc?export=download&id=1WJkJ-YI80xK61URcRoxughn7cV6lwxeJ",
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
        audio: "https://drive.google.com/uc?export=download&id=1yQg7fV0aBpiVV2cGsGJF6_NDf6JjhKxq",
      ),
      CancionClasica(
        titulo: "Juro Que Te Gusto",
        audio: "assets/audio/clasicos/26 - Elisa Guerrero - Juro que te gusto.mp3",
      ),
      CancionClasica(
        titulo: "Loco De Amor",
        audio: "https://drive.google.com/uc?export=download&id=1Qor8QNGY6-p8eOeRyBGtcIfUtB3Nt0YN",
      ),
      CancionClasica(
        titulo: "Enguayaba y Barrigona",
        audio: "https://drive.google.com/uc?export=download&id=1cn6Vq_7XBEHZEwRRtQRjrSVnr0A2q8_C",
      ),
      CancionClasica(
        titulo: "El Guayabo de Elisa",
        audio: "https://drive.google.com/uc?export=download&id=1osh5WqtlOpmDdefa3IPbKxS_osQPr82H",
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
        audio: "assets/audio/clasicos/27 Reynaldo Armas - A Usted.mp3",
      ),
      CancionClasica(
        titulo: "Laguna Vieja",
        audio: "https://drive.google.com/uc?export=download&id=1HLtH9kW_WpFh4kFEftcugq9Gczayd-rm",
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
        audio: "assets/audio/clasicos/29_Añoranzas_Jorge Guerrero.mp3",
      ),
      CancionClasica(
        titulo: "Guayabo de Mes y Pico",
        audio: "https://drive.google.com/uc?export=download&id=1l9drYQQFZ_zOXIBzPvuZ15ZxoR2yBj9p",
      ),
    ],
  ),
ClasicoLlano(
  artista: "Julio Miranda",
  apodo: "El Cantautor del Amor",
  estado: "Sucre",
  pais: "Venezuela",
  imagen: "assets/images/clasicos/Julio_Miranda.png",
  canciones: [
    CancionClasica(
      titulo: "Egoísmo",
      audio: "https://drive.google.com/uc?export=download&id=1Qkpkltef2VEXNWnsm0v3ASXpOdN0Q9EP",
    ),
    CancionClasica(
      titulo: "Los Años Pegan",
      audio: "assets/audio/clasicos/julio_miranda/los_anos_pegan.mp3",
    ),
  ],
),

ClasicoLlano(
  artista: "Freddy Salcedo",
  apodo: "Su Majestad del Llano",
  estado: "Portuguesa",
  pais: "Venezuela",
  imagen: "assets/images/clasicos/Freddy_Salcedo.png",
  canciones: [
    CancionClasica(
      titulo: "Viejo Soguero",
      audio: "assets/audio/clasicos/freddy_salcedo/viejo_soguero.mp3",
    ),
    CancionClasica(
      titulo: "La Fundadora",
      audio: "assets/audio/clasicos/freddy_salcedo/la_fundadora.mp3",
    ),
  ],
),

ClasicoLlano(
  artista: "Sexagésimo",
  apodo: "El Tenor del Llano",
  estado: "Portuguesa",
  pais: "Venezuela",
  imagen: "assets/images/clasicos/Sexagesimo.png",
  canciones: [
    CancionClasica(
      titulo: "Vagabundo Enamorado",
      audio: "assets/audio/clasicos/sexagesimo/vagabundo_enamorado.mp3",
    ),
    CancionClasica(
      titulo: "Déjame Nacer",
      audio: "assets/audio/clasicos/sexagesimo/dejame_nacer.mp3",
    ),
  ],
),
ClasicoLlano(
  artista: "Nelson Morales",
  apodo: "El Ruiseñor de Atamaica",
  estado: "Apure",
  pais: "Venezuela",
  imagen: "assets/images/clasicos/Nelson_Morales.png",
  canciones: [
    CancionClasica(
      titulo: "Cándida Rosa",
      audio: "assets/audio/clasicos/nelson_morales/candida_rosa.mp3",
    ),
    CancionClasica(
      titulo: "El Auténtico Llanero",
      audio: "assets/audio/clasicos/nelson_morales/el_autentico_llanero.mp3",
    ),
    CancionClasica(
      titulo: "Las Inquietudes de Kirpa",
      audio: "https://drive.google.com/uc?export=download&id=1JKdGvOGWy9MvgpjzMGMe5me7Kt04EH_R",
    ),
    CancionClasica(
      titulo: "Dos Copleros De Mi Tierra",
      audio: "https://drive.google.com/uc?export=download&id=1fBfbIVccHrsBRg2Yw4oo_AnMYE7fTb9m",
    ),
    CancionClasica(
      titulo: "Dos Apureños Completos",
      audio: "https://drive.google.com/uc?export=download&id=1src9nIYay_8sImFk-52JY8kboRdV7rLX",
    ),
  ],
),

ClasicoLlano(
  artista: "Cristóbal Jiménez",
  apodo: "El Coplero de Oro",
  estado: "Apure",
  pais: "Venezuela",
  imagen: "assets/images/clasicos/Cristobal_Jimenez.png",
  canciones: [
    CancionClasica(
      titulo: "Soy un Trovador",
      audio: "assets/audio/clasicos/cristobal_jimenez/soy_un_trovador.mp3",
    ),
    CancionClasica(
      titulo: "Alma Apureña",
      audio: "assets/audio/clasicos/cristobal_jimenez/alma_apurena.mp3",
    ),
  ],
),

ClasicoLlano(
  artista: "Dámaso Figueredo",
  apodo: "El Llanero Completo",
  estado: "Guárico",
  pais: "Venezuela",
  imagen: "assets/images/clasicos/Damaso_Figueredo.png",
  canciones: [
    CancionClasica(
      titulo: "Lo Que Yo Le Pida Deme",
      audio: "assets/audio/clasicos/damaso_figueredo/lo_que_yo_le_pida_deme.mp3",
    ),
    CancionClasica(
      titulo: "He Perdido en Poco Tiempo",
      audio: "assets/audio/clasicos/damaso_figueredo/he_perdido_en_poco_tiempo.mp3",
    ),
  ],
),
ClasicoLlano(
  artista: "José Alí Nieves",
  apodo: "El Pico de Oro",
  estado: "Apure",
  pais: "Venezuela",
  imagen: "assets/images/clasicos/Jose_Ali_Nieves.png",
  canciones: [
    CancionClasica(
      titulo: "Pescador del Río Apure",
      audio: "assets/audio/clasicos/jose_ali_nieves/pescador_del_rio_apure.mp3",
    ),
    CancionClasica(
      titulo: "Rumbo al Jagüey",
      audio: "assets/audio/clasicos/jose_ali_nieves/rumbo_al_jaguey.mp3",
    ),
  ],
),

ClasicoLlano(
  artista: "Julio Pantoja",
  apodo: "El Hijo de Monasterios",
  estado: "Guárico",
  pais: "Venezuela",
  imagen: "assets/images/clasicos/Julio_Pantoja.png",
  canciones: [
    CancionClasica(
      titulo: "Chungo Amarillo Jovero",
      audio: "assets/audio/clasicos/julio_pantoja/chungo_amarillo_jovero.mp3",
    ),
    CancionClasica(
      titulo: "Llanero que canta y silva",
      audio: "assets/audio/clasicos/julio_pantoja/llanero_que_canta_y_silva.mp3",

    ),
  ],
),

ClasicoLlano(
  artista: "José Jiménez",
  apodo: "El Pollo de Orichuna",
  estado: "Apure",
  pais: "Venezuela",
  imagen: "assets/images/clasicos/Jose_Jimenez.png",
  canciones: [
    CancionClasica(
      titulo: "Muchacha Flor de mi Llano",
      audio: "assets/audio/clasicos/jose_jimenez/muchacha_flor_de_mi_llano.mp3",
    ),
    CancionClasica(
      titulo: "Tengo el Corazón Enfermo",
      audio: "assets/audio/clasicos/jose_jimenez/tengo_el_corazon_enfermo.mp3",
    ),
  ],
),
ClasicoLlano(
  artista: "Humberto Salas",
  apodo: "El Tigre de Guayabal",
  estado: "Cojedes",
  pais: "Venezuela",
  imagen: "assets/images/clasicos/Humberto_Salas.png",
  canciones: [
    CancionClasica(
      titulo: "Dame Tu Amor",
      audio: "assets/audio/clasicos/humberto_salas/dame_tu_amor.mp3",
    ),
    CancionClasica(
      titulo: "Déjame Amarte",
      audio: "assets/audio/clasicos/humberto_salas/dejame_amarte.mp3",
    ),
  ],
),

ClasicoLlano(
  artista: "Jesús Quintero",
  apodo: "El Tigre de Matanegra",
  estado: "Barinas",
  pais: "Venezuela",
  imagen: "assets/images/clasicos/Jesus_Quintero.png",
  canciones: [
    CancionClasica(
      titulo: "Autor que Canta y Escribe",
      audio: "assets/audio/clasicos/jesus_quintero/autor_que_canta_y_escribe.mp3",
    ),
    CancionClasica(
      titulo: "Un Llanero Enamorado",
      audio: "assets/audio/clasicos/jesus_quintero/un_llanero_enamorado.mp3",
    ),
  ],
),

ClasicoLlano(
  artista: "Ramón Blanco",
  apodo: "El Coplero",
  estado: "Cojedes",
  pais: "Venezuela",
  imagen: "assets/images/clasicos/Ramon_Blanco.png",
  canciones: [
    CancionClasica(
      titulo: "Resignación",
      audio: "assets/audio/clasicos/ramon_blanco/resignacion.mp3",
    ),
    CancionClasica(
      titulo: "Te Rogué que No te Fueras",
      audio: "assets/audio/clasicos/ramon_blanco/te_rogue_que_no_te_fueras.mp3",
    ),
  ],
),

ClasicoLlano(
  artista: "Rafael Alvarado",
  apodo: "El Gallo de Tinaquillo",
  estado: "Cojedes",
  pais: "Venezuela",
  imagen: "assets/images/clasicos/Rafael_Alvarado.png",
  canciones: [
    CancionClasica(
      titulo: "Lamento de Amor",
      audio: "assets/audio/clasicos/rafael_alvarado/lamento_de_amor.mp3",
    ),
    CancionClasica(
      titulo: "Recuerdo de Dos Pasajes",
      audio: "assets/audio/clasicos/rafael_alvarado/recuerdo_de_dos_pasajes.mp3",
    ),
  ],
),
ClasicoLlano(
  artista: "Yaneth de Venezuela",
  apodo: "",
  estado: "Cojedes",
  pais: "Venezuela",
  imagen: "assets/images/artistas/Tardes_Cojedeñas_Yaneth_de_Venezuela.png",
  canciones: [
    CancionClasica(
      titulo: "Tardes Cojedeñas",
      audio: "assets/audio/yaneth_de_venezuela/tardes_cojedenas.mp3",
    ),
  ],
),


ClasicoLlano(
  artista: "Simón Díaz",
  apodo: "Tío Simón",
  estado: "Guárico",
  pais: "Venezuela",
  imagen: "https://drive.google.com/uc?export=view&id=1_5AwA9RMFZzNWYavt8eaRXVQjgpe0JqQ",
  canciones: [],
),

];
