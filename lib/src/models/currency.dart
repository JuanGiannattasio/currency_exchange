/// Supported fiat currencies based on ISO-4217 standard.
///
/// This enum contains all major fiat currencies supported by the exchange rate API.
/// Cryptocurrencies are explicitly not supported.
enum Currency {
  /// United Arab Emirates Dirham
  aed,

  /// Afghan Afghani
  afn,

  /// Albanian Lek
  all,

  /// Armenian Dram
  amd,

  /// Netherlands Antillean Guilder
  ang,

  /// Angolan Kwanza
  aoa,

  /// Argentine Peso
  ars,

  /// Australian Dollar
  aud,

  /// Aruban Florin
  awg,

  /// Azerbaijani Manat
  azn,

  /// Bosnia-Herzegovina Convertible Mark
  bam,

  /// Barbadian Dollar
  bbd,

  /// Bangladeshi Taka
  bdt,

  /// Bulgarian Lev
  bgn,

  /// Bahraini Dinar
  bhd,

  /// Burundian Franc
  bif,

  /// Bermudian Dollar
  bmd,

  /// Brunei Dollar
  bnd,

  /// Bolivian Boliviano
  bob,

  /// Brazilian Real
  brl,

  /// Bahamian Dollar
  bsd,

  /// Bhutanese Ngultrum
  btn,

  /// Botswanan Pula
  bwp,

  /// Belarusian Ruble
  byn,

  /// Belize Dollar
  bzd,

  /// Canadian Dollar
  cad,

  /// Congolese Franc
  cdf,

  /// Swiss Franc
  chf,

  /// Chilean Peso
  clp,

  /// Chinese Yuan
  cny,

  /// Colombian Peso
  cop,

  /// Costa Rican Colón
  crc,

  /// Cuban Peso
  cup,

  /// Cape Verdean Escudo
  cve,

  /// Czech Republic Koruna
  czk,

  /// Djiboutian Franc
  djf,

  /// Danish Krone
  dkk,

  /// Dominican Peso
  dop,

  /// Algerian Dinar
  dzd,

  /// Egyptian Pound
  egp,

  /// Eritrean Nakfa
  ern,

  /// Ethiopian Birr
  etb,

  /// Euro
  eur,

  /// Fijian Dollar
  fjd,

  /// Falkland Islands Pound
  fkp,

  /// Faroese Króna
  fok,

  /// British Pound Sterling
  gbp,

  /// Georgian Lari
  gel,

  /// Guernsey Pound
  ggp,

  /// Ghanaian Cedi
  ghs,

  /// Gibraltar Pound
  gip,

  /// Gambian Dalasi
  gmd,

  /// Guinean Franc
  gnf,

  /// Guatemalan Quetzal
  gtq,

  /// Guyanaese Dollar
  gyd,

  /// Hong Kong Dollar
  hkd,

  /// Honduran Lempira
  hnl,

  /// Croatian Kuna
  hrk,

  /// Haitian Gourde
  htg,

  /// Hungarian Forint
  huf,

  /// Indonesian Rupiah
  idr,

  /// Israeli New Sheqel
  ils,

  /// Manx pound
  imp,

  /// Indian Rupee
  inr,

  /// Iraqi Dinar
  iqd,

  /// Iranian Rial
  irr,

  /// Icelandic Króna
  isk,

  /// Jersey Pound
  jep,

  /// Jamaican Dollar
  jmd,

  /// Jordanian Dinar
  jod,

  /// Japanese Yen
  jpy,

  /// Kenyan Shilling
  kes,

  /// Kyrgystani Som
  kgs,

  /// Cambodian Riel
  khr,

  /// Comorian Franc
  kmf,

  /// North Korean Won
  kpw,

  /// South Korean Won
  krw,

  /// Kuwaiti Dinar
  kwd,

  /// Cayman Islands Dollar
  kyd,

  /// Kazakhstani Tenge
  kzt,

  /// Laotian Kip
  lak,

  /// Lebanese Pound
  lbp,

  /// Sri Lankan Rupee
  lkr,

  /// Liberian Dollar
  lrd,

  /// Lesotho Loti
  lsl,

  /// Libyan Dinar
  lyd,

  /// Moroccan Dirham
  mad,

  /// Moldovan Leu
  mdl,

  /// Malagasy Ariary
  mga,

  /// Macedonian Denar
  mkd,

  /// Myanma Kyat
  mmk,

  /// Mongolian Tugrik
  mnt,

  /// Macanese Pataca
  mop,

  /// Mauritanian Ouguiya
  mru,

  /// Mauritian Rupee
  mur,

  /// Maldivian Rufiyaa
  mvr,

  /// Malawian Kwacha
  mwk,

  /// Mexican Peso
  mxn,

  /// Malaysian Ringgit
  myr,

  /// Mozambican Metical
  mzn,

  /// Namibian Dollar
  nad,

  /// Nigerian Naira
  ngn,

  /// Nicaraguan Córdoba
  nio,

  /// Norwegian Krone
  nok,

  /// Nepalese Rupee
  npr,

  /// New Zealand Dollar
  nzd,

  /// Omani Rial
  omr,

  /// Panamanian Balboa
  pab,

  /// Peruvian Nuevo Sol
  pen,

  /// Papua New Guinean Kina
  pgk,

  /// Philippine Peso
  php,

  /// Pakistani Rupee
  pkr,

  /// Polish Zloty
  pln,

  /// Paraguayan Guarani
  pyg,

  /// Qatari Rial
  qar,

  /// Romanian Leu
  ron,

  /// Serbian Dinar
  rsd,

  /// Russian Ruble
  rub,

  /// Rwandan Franc
  rwf,

  /// Saudi Riyal
  sar,

  /// Solomon Islands Dollar
  sbd,

  /// Seychellois Rupee
  scr,

  /// Sudanese Pound
  sdg,

  /// Swedish Krona
  sek,

  /// Singapore Dollar
  sgd,

  /// Saint Helena Pound
  shp,

  /// Sierra Leonean Leone
  sle,

  /// Somali Shilling
  sos,

  /// Surinamese Dollar
  srd,

  /// South Sudanese Pound
  ssp,

  /// São Tomé and Príncipe Dobra
  stn,

  /// Syrian Pound
  syp,

  /// Swazi Lilangeni
  szl,

  /// Thai Baht
  thb,

  /// Tajikistani Somoni
  tjs,

  /// Turkmenistani Manat
  tmt,

  /// Tunisian Dinar
  tnd,

  /// Tongan Paʻanga
  top,

  /// Turkish Lira
  try_,

  /// Trinidad and Tobago Dollar
  ttd,

  /// Tuvaluan Dollar
  tvd,

  /// New Taiwan Dollar
  twd,

  /// Tanzanian Shilling
  tzs,

  /// Ukrainian Hryvnia
  uah,

  /// Ugandan Shilling
  ugx,

  /// United States Dollar
  usd,

  /// Uruguayan Peso
  uyu,

  /// Uzbekistan Som
  uzs,

  /// Venezuelan Bolívar
  ves,

  /// Vietnamese Dong
  vnd,

  /// Vanuatu Vatu
  vuv,

  /// Samoan Tala
  wst,

  /// CFA Franc BEAC
  xaf,

  /// East Caribbean Dollar
  xcd,

  /// Special Drawing Rights
  xdr,

  /// CFA Franc BCEAO
  xof,

  /// CFP Franc
  xpf,

  /// Yemeni Rial
  yer,

  /// South African Rand
  zar,

  /// Zambian Kwacha
  zmw,

  /// Zimbabwean Dollar
  zwl;

  /// Returns the uppercase currency code (e.g., 'USD', 'EUR')
  String get code {
    if (this == Currency.try_) {
      return 'TRY';
    }
    return name.toUpperCase();
  }

  /// Creates a Currency from a string code (case-insensitive)
  ///
  /// Throws [ArgumentError] if the code is not a valid currency.
  static Currency fromCode(String code) {
    final normalizedCode = code.toLowerCase();

    if (normalizedCode == 'try') {
      return Currency.try_;
    }

    try {
      return Currency.values.firstWhere((c) => c.name == normalizedCode);
    } catch (_) {
      throw ArgumentError('Unsupported currency code: $code');
    }
  }
}
