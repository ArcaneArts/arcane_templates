// GENERATED – do not modify by hand

// ignore_for_file: camel_case_types
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: constant_identifier_names
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: unused_element
import "package:arcane_models/arcane_models.dart";import "package:artifact/artifact.dart";import "dart:core";
typedef _0=ArtifactCodecUtil;typedef _1=Map<String, dynamic>;typedef _2=List<String>;typedef _3=String;typedef _4=dynamic;typedef _5=int;typedef _6=User;typedef _7=UserSettings;typedef _8=ServerCommand;typedef _9=ServerResponse;typedef _a=ResponseOK;typedef _b=ResponseError;typedef _c=ArcaneServerSignature;typedef _d=ArgumentError;typedef _e=bool;typedef _f=ThemeMode;typedef _g=ArtifactAccessor;typedef _h=List<dynamic>;
const _2 _S=['name','email','profileHash','Missing required User."name" in map ','Missing required User."email" in map ','themeMode','user','Missing required ServerCommand."user" in map ','_subclass_ServerResponse','ResponseOK','ResponseError','Missing required ServerResponse."user" in map ','Missing required ResponseOK."user" in map ','message','Missing required ResponseError."user" in map ','Missing required ResponseError."message" in map ','signature','session','time','Missing required ArcaneServerSignature."signature" in map ','Missing required ArcaneServerSignature."session" in map ','Missing required ArcaneServerSignature."time" in map ','arcane_models'];const _h _V=[ThemeMode.system];const _e _T=true;const _e _F=false;_5 _ = ((){if(!_g.$i(_S[22])){_g.$r(_S[22],_g(isArtifact: $isArtifact,artifactMirror:{},constructArtifact:$constructArtifact,artifactToMap:$artifactToMap,artifactFromMap:$artifactFromMap));}
return 0;})();
extension $User on _6{
  _6 get _H=>this;
  _3 toJson({bool pretty=_F})=>_0.j(pretty, toMap);
  _3 toYaml()=>_0.y(toMap);
  _3 toToon()=>_0.b(toMap);
  _3 toToml()=>_0.u(toMap);
  _3 toXml({bool pretty=_F})=>_0.z(pretty,toMap);
  _3 toProperties()=>_0.h(toMap);
  _1 toMap(){_;return <_3, _4>{_S[0]:_0.ea(name),_S[1]:_0.ea(email),_S[2]:_0.ea(profileHash),}.$nn;}
  static _6 fromJson(String j)=>fromMap(_0.o(j));
  static _6 fromYaml(String j)=>fromMap(_0.v(j));
  static _6 fromToon(String j)=>fromMap(_0.i(j));
  static _6 fromToml(String j)=>fromMap(_0.t(j));
  static _6 fromProperties(String j)=>fromMap(_0.g(j));
  static _6 fromMap(_1 r){_;_1 m=r.$nn;return _6(name: m.$c(_S[0])? _0.da(m[_S[0]], _3) as _3:(throw _d('${_S[3]}$m.')),email: m.$c(_S[1])? _0.da(m[_S[1]], _3) as _3:(throw _d('${_S[4]}$m.')),profileHash: m.$c(_S[2]) ?  _0.da(m[_S[2]], _3) as _3? : null,);}
  _6 copyWith({_3? name,_3? email,_3? profileHash,_e deleteProfileHash=_F,})=>_6(name: name??_H.name,email: email??_H.email,profileHash: deleteProfileHash?null:(profileHash??_H.profileHash),);
  static _6 get newInstance=>_6(name: '',email: '',);
}
extension $UserSettings on _7{
  _7 get _H=>this;
  _3 toJson({bool pretty=_F})=>_0.j(pretty, toMap);
  _3 toYaml()=>_0.y(toMap);
  _3 toToon()=>_0.b(toMap);
  _3 toToml()=>_0.u(toMap);
  _3 toXml({bool pretty=_F})=>_0.z(pretty,toMap);
  _3 toProperties()=>_0.h(toMap);
  _1 toMap(){_;return <_3, _4>{_S[5]:themeMode.name,}.$nn;}
  static _7 fromJson(String j)=>fromMap(_0.o(j));
  static _7 fromYaml(String j)=>fromMap(_0.v(j));
  static _7 fromToon(String j)=>fromMap(_0.i(j));
  static _7 fromToml(String j)=>fromMap(_0.t(j));
  static _7 fromProperties(String j)=>fromMap(_0.g(j));
  static _7 fromMap(_1 r){_;_1 m=r.$nn;return _7(themeMode: m.$c(_S[5]) ? _0.e(ThemeMode.values, m[_S[5]]) as ThemeMode : _V[0],);}
  _7 copyWith({_f? themeMode,_e resetThemeMode=_F,})=>_7(themeMode: resetThemeMode?_V[0]:(themeMode??_H.themeMode),);
  static _7 get newInstance=>_7();
}
extension $ServerCommand on _8{
  _8 get _H=>this;
  _3 toJson({bool pretty=_F})=>_0.j(pretty, toMap);
  _3 toYaml()=>_0.y(toMap);
  _3 toToon()=>_0.b(toMap);
  _3 toToml()=>_0.u(toMap);
  _3 toXml({bool pretty=_F})=>_0.z(pretty,toMap);
  _3 toProperties()=>_0.h(toMap);
  _1 toMap(){_;return <_3, _4>{_S[6]:_0.ea(user),}.$nn;}
  static _8 fromJson(String j)=>fromMap(_0.o(j));
  static _8 fromYaml(String j)=>fromMap(_0.v(j));
  static _8 fromToon(String j)=>fromMap(_0.i(j));
  static _8 fromToml(String j)=>fromMap(_0.t(j));
  static _8 fromProperties(String j)=>fromMap(_0.g(j));
  static _8 fromMap(_1 r){_;_1 m=r.$nn;return _8(user: m.$c(_S[6])? _0.da(m[_S[6]], _3) as _3:(throw _d('${_S[7]}$m.')),);}
  _8 copyWith({_3? user,})=>_8(user: user??_H.user,);
  static _8 get newInstance=>_8(user: '',);
}
extension $ServerResponse on _9{
  _9 get _H=>this;
  _3 toJson({bool pretty=_F})=>_0.j(pretty, toMap);
  _3 toYaml()=>_0.y(toMap);
  _3 toToon()=>_0.b(toMap);
  _3 toToml()=>_0.u(toMap);
  _3 toXml({bool pretty=_F})=>_0.z(pretty,toMap);
  _3 toProperties()=>_0.h(toMap);
  _1 toMap(){_;if (_H is _a){return (_H as _a).toMap();}if (_H is _b){return (_H as _b).toMap();}return <_3, _4>{_S[6]:_0.ea(user),}.$nn;}
  static _9 fromJson(String j)=>fromMap(_0.o(j));
  static _9 fromYaml(String j)=>fromMap(_0.v(j));
  static _9 fromToon(String j)=>fromMap(_0.i(j));
  static _9 fromToml(String j)=>fromMap(_0.t(j));
  static _9 fromProperties(String j)=>fromMap(_0.g(j));
  static _9 fromMap(_1 r){_;_1 m=r.$nn;if(m.$c(_S[8])){String _I=m[_S[8]] as _3;if(_I==_S[9]){return $ResponseOK.fromMap(m);}if(_I==_S[10]){return $ResponseError.fromMap(m);}}return _9(user: m.$c(_S[6])? _0.da(m[_S[6]], _3) as _3:(throw _d('${_S[11]}$m.')),);}
  _9 copyWith({_3? user,}){if (_H is _a){return (_H as _a).copyWith(user: user,);}if (_H is _b){return (_H as _b).copyWith(user: user,);}return _9(user: user??_H.user,);}
  static _9 get newInstance=>_9(user: '',);
}
extension $ResponseOK on _a{
  _a get _H=>this;
  _3 toJson({bool pretty=_F})=>_0.j(pretty, toMap);
  _3 toYaml()=>_0.y(toMap);
  _3 toToon()=>_0.b(toMap);
  _3 toToml()=>_0.u(toMap);
  _3 toXml({bool pretty=_F})=>_0.z(pretty,toMap);
  _3 toProperties()=>_0.h(toMap);
  _1 toMap(){_;return <_3, _4>{_S[8]: 'ResponseOK',_S[6]:_0.ea(user),}.$nn;}
  static _a fromJson(String j)=>fromMap(_0.o(j));
  static _a fromYaml(String j)=>fromMap(_0.v(j));
  static _a fromToon(String j)=>fromMap(_0.i(j));
  static _a fromToml(String j)=>fromMap(_0.t(j));
  static _a fromProperties(String j)=>fromMap(_0.g(j));
  static _a fromMap(_1 r){_;_1 m=r.$nn;return _a(user: m.$c(_S[6])? _0.da(m[_S[6]], _3) as _3:(throw _d('${_S[12]}$m.')),);}
  _a copyWith({_3? user,})=>_a(user: user??_H.user,);
  static _a get newInstance=>_a(user: '',);
}
extension $ResponseError on _b{
  _b get _H=>this;
  _3 toJson({bool pretty=_F})=>_0.j(pretty, toMap);
  _3 toYaml()=>_0.y(toMap);
  _3 toToon()=>_0.b(toMap);
  _3 toToml()=>_0.u(toMap);
  _3 toXml({bool pretty=_F})=>_0.z(pretty,toMap);
  _3 toProperties()=>_0.h(toMap);
  _1 toMap(){_;return <_3, _4>{_S[8]: 'ResponseError',_S[6]:_0.ea(user),_S[13]:_0.ea(message),}.$nn;}
  static _b fromJson(String j)=>fromMap(_0.o(j));
  static _b fromYaml(String j)=>fromMap(_0.v(j));
  static _b fromToon(String j)=>fromMap(_0.i(j));
  static _b fromToml(String j)=>fromMap(_0.t(j));
  static _b fromProperties(String j)=>fromMap(_0.g(j));
  static _b fromMap(_1 r){_;_1 m=r.$nn;return _b(user: m.$c(_S[6])? _0.da(m[_S[6]], _3) as _3:(throw _d('${_S[14]}$m.')),message: m.$c(_S[13])? _0.da(m[_S[13]], _3) as _3:(throw _d('${_S[15]}$m.')),);}
  _b copyWith({_3? user,_3? message,})=>_b(user: user??_H.user,message: message??_H.message,);
  static _b get newInstance=>_b(user: '',message: '',);
}
extension $ArcaneServerSignature on _c{
  _c get _H=>this;
  _3 toJson({bool pretty=_F})=>_0.j(pretty, toMap);
  _3 toYaml()=>_0.y(toMap);
  _3 toToon()=>_0.b(toMap);
  _3 toToml()=>_0.u(toMap);
  _3 toXml({bool pretty=_F})=>_0.z(pretty,toMap);
  _3 toProperties()=>_0.h(toMap);
  _1 toMap(){_;return <_3, _4>{_S[16]:_0.ea(signature),_S[17]:_0.ea(session),_S[18]:_0.ea(time),}.$nn;}
  static _c fromJson(String j)=>fromMap(_0.o(j));
  static _c fromYaml(String j)=>fromMap(_0.v(j));
  static _c fromToon(String j)=>fromMap(_0.i(j));
  static _c fromToml(String j)=>fromMap(_0.t(j));
  static _c fromProperties(String j)=>fromMap(_0.g(j));
  static _c fromMap(_1 r){_;_1 m=r.$nn;return _c(signature: m.$c(_S[16])? _0.da(m[_S[16]], _3) as _3:(throw _d('${_S[19]}$m.')),session: m.$c(_S[17])? _0.da(m[_S[17]], _3) as _3:(throw _d('${_S[20]}$m.')),time: m.$c(_S[18])? _0.da(m[_S[18]], _5) as _5:(throw _d('${_S[21]}$m.')),);}
  _c copyWith({_3? signature,_3? session,_5? time,_5? deltaTime,})=>_c(signature: signature??_H.signature,session: session??_H.session,time: deltaTime!=null?(time??_H.time)+deltaTime:time??_H.time,);
  static _c get newInstance=>_c(signature: '',session: '',time: 0,);
}

bool $isArtifact(dynamic v)=>v==null?false : v is! Type ?$isArtifact(v.runtimeType):v == _6 ||v == _7 ||v == _8 ||v == _9 ||v == _a ||v == _b ||v == _c ;
T $constructArtifact<T>() => T==_6 ?$User.newInstance as T :T==_7 ?$UserSettings.newInstance as T :T==_8 ?$ServerCommand.newInstance as T :T==_9 ?$ServerResponse.newInstance as T :T==_a ?$ResponseOK.newInstance as T :T==_b ?$ResponseError.newInstance as T :T==_c ?$ArcaneServerSignature.newInstance as T : throw Exception();
_1 $artifactToMap(Object o)=>o is _6 ?o.toMap():o is _7 ?o.toMap():o is _8 ?o.toMap():o is _9 ?o.toMap():o is _a ?o.toMap():o is _b ?o.toMap():o is _c ?o.toMap():throw Exception();
T $artifactFromMap<T>(_1 m)=>T==_6 ?$User.fromMap(m) as T:T==_7 ?$UserSettings.fromMap(m) as T:T==_8 ?$ServerCommand.fromMap(m) as T:T==_9 ?$ServerResponse.fromMap(m) as T:T==_a ?$ResponseOK.fromMap(m) as T:T==_b ?$ResponseError.fromMap(m) as T:T==_c ?$ArcaneServerSignature.fromMap(m) as T: throw Exception();
