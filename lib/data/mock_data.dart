import '../models/product.dart';

const occasionOptions = [
  'Everyday',
  'Work',
  'Date Night',
  'Festival',
  'Wedding',
];

/// Outfit type choices depend on the selected occasion.
const Map<String, List<String>> outfitTypesByOccasion = {
  'Everyday': [
    'T-Shirt & Jeans',
    'Kurti & Leggings',
    'Casual Dress',
    'Co-ord Set',
  ],

  'Work': [
    'Blazer Set',
    'Shirt & Trousers',
    'Pencil Skirt Set',
    'Kurti & Palazzo',
  ],

  'Date Night': [
    'Bodycon Dress',
    'Slip Dress',
    'Jumpsuit',
    'Co-ord Set',
  ],

  'Festival': [
    'Anarkali',
    'Lehenga',
    'Indo-Western Set',
    'Kurta Set',
  ],

  'Wedding': [
    'Saree',
    'Lehenga',
    'Half Saree',
    'Salwar Kameez',
    'Sherwani',
    'Kurta Pyjama',
  ],
};

/// Temporary local product data.
///
/// This is still mock data.
/// We will replace this with a real fashion dataset later.
final mockProducts = <Product>[
  Product(
    id: 'p1',
    name: 'Tailored Blazer Set',
    brand: 'Field Studio',
    price: 2899,
    imageUrl: null,
    category: 'Formal Wear',
    outfitType: 'Blazer Set',
    color: 'Olive',
    occasion: 'Work',
    style: 'Formal',
    compatibleSkinTones: [
      'honey',
      'caramel',
      'umber',
    ],
  ),

  Product(
    id: 'p2',
    name: 'Ochre Kurti & Palazzo',
    brand: 'North Loom',
    price: 1499,
    imageUrl: null,
    category: 'Ethnic Wear',
    outfitType: 'Kurti & Palazzo',
    color: 'Ochre',
    occasion: 'Work',
    style: 'Traditional',
    compatibleSkinTones: [
      'warmBeige',
      'honey',
      'caramel',
      'umber',
    ],
  ),

  Product(
    id: 'p3',
    name: 'Draped Slip Dress',
    brand: 'Vera Row',
    price: 3299,
    imageUrl: null,
    category: 'Western Wear',
    outfitType: 'Slip Dress',
    color: 'Rose',
    occasion: 'Date Night',
    style: 'Trendy',
    compatibleSkinTones: [
      'porcelain',
      'warmBeige',
      'honey',
      'caramel',
    ],
  ),

  Product(
    id: 'p4',
    name: 'Emerald Bodycon Dress',
    brand: 'Kiln & Co',
    price: 1899,
    imageUrl: null,
    category: 'Western Wear',
    outfitType: 'Bodycon Dress',
    color: 'Emerald',
    occasion: 'Date Night',
    style: 'Trendy',
    compatibleSkinTones: [
      'honey',
      'caramel',
      'umber',
      'deepEbony',
    ],
  ),

  Product(
    id: 'p5',
    name: 'Ivory Silk Saree',
    brand: 'Vera Row',
    price: 6499,
    imageUrl: null,
    category: 'Ethnic Wear',
    outfitType: 'Saree',
    color: 'Ivory',
    occasion: 'Wedding',
    style: 'Traditional',
    compatibleSkinTones: [
      'porcelain',
      'warmBeige',
      'honey',
      'caramel',
      'umber',
      'deepEbony',
    ],
  ),

  Product(
    id: 'p6',
    name: 'Maroon Bridal Lehenga',
    brand: 'Field Studio',
    price: 8999,
    imageUrl: null,
    category: 'Ethnic Wear',
    outfitType: 'Lehenga',
    color: 'Maroon',
    occasion: 'Wedding',
    style: 'Traditional',
    compatibleSkinTones: [
      'honey',
      'caramel',
      'umber',
      'deepEbony',
    ],
  ),

  Product(
    id: 'p7',
    name: 'Ivory Sherwani',
    brand: 'North Loom',
    price: 7499,
    imageUrl: null,
    category: 'Ethnic Wear',
    outfitType: 'Sherwani',
    color: 'Ivory',
    occasion: 'Wedding',
    style: 'Traditional',
    compatibleSkinTones: [
      'honey',
      'caramel',
      'umber',
      'deepEbony',
    ],
  ),

  Product(
    id: 'p8',
    name: 'Rose Salwar Kameez',
    brand: 'Vera Row',
    price: 3199,
    imageUrl: null,
    category: 'Ethnic Wear',
    outfitType: 'Salwar Kameez',
    color: 'Rose',
    occasion: 'Wedding',
    style: 'Traditional',
    compatibleSkinTones: [
      'porcelain',
      'warmBeige',
      'honey',
      'caramel',
    ],
  ),

  Product(
    id: 'p9',
    name: 'Mustard Anarkali',
    brand: 'Kiln & Co',
    price: 2799,
    imageUrl: null,
    category: 'Ethnic Wear',
    outfitType: 'Anarkali',
    color: 'Mustard',
    occasion: 'Festival',
    style: 'Traditional',
    compatibleSkinTones: [
      'warmBeige',
      'honey',
      'caramel',
      'umber',
      'deepEbony',
    ],
  ),

  Product(
    id: 'p10',
    name: 'Cotton Kurti & Leggings',
    brand: 'North Loom',
    price: 999,
    imageUrl: null,
    category: 'Casual Wear',
    outfitType: 'Kurti & Leggings',
    color: 'Grey',
    occasion: 'Everyday',
    style: 'Casual',
    compatibleSkinTones: [
      'porcelain',
      'warmBeige',
      'honey',
      'caramel',
      'umber',
      'deepEbony',
    ],
  ),
];