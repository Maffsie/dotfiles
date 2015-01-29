" Vim syntax file
" Language:     BIND zone files (RFC1035)
" Maintainer:   Julian Mehnle <julian@mehnle.net>
" URL:          http://www.mehnle.net/source/odds+ends/vim/syntax/
" Last Change:  Thu 2006-04-20 12:30:45 UTC
"
" Based on an earlier version by Вячеслав Горбанев (Slava Gorbanev), with
" heavy modifications.
"
" $Id: bindzone.vim,v 1.2 2006/04/20 22:06:21 vimboss Exp $

" For version 5.x: Clear all syntax items
" For version 6.x: Quit when a syntax file was already loaded
if version < 600
  syntax clear
elseif exists("b:current_syntax")
  finish
endif

syn case match

" Directives
syn region      zoneRRecord     start=/^/ end=/$/ contains=zoneOwnerName,zoneSpecial,zoneTTL,zoneClass,zoneRRType,zoneComment,zoneUnknown

"bind doesn't require these to be uppercase but meh
syn match       zoneDirective   /^\$ORIGIN\s\+/   nextgroup=zoneOrigin,zoneUnknown
syn match       zoneDirective   /^\$TTL\s\+/      nextgroup=zoneNumber,zoneUnknown
"bind actually doesn't require that $INCLUDE paths be encased in quotes but I don't feel like fixing it
syn match       zoneDirective   /^\$INCLUDE\s\+/  nextgroup=zoneText,zoneUnknown
syn match       zoneDirective   /^\$GENERATE\s/

syn match       zoneUnknown     contained /\S\+/

syn match       zoneOwnerName   contained /^[^[:space:]!"#$%&'()*+,\/:;<=>?@[\]\^`{|}~]\+\(\s\|;\)\@=/ nextgroup=zoneTTL,zoneClass,zoneRRType skipwhite
syn match       zoneOrigin      contained  /[^[:space:]!"#$%&'()*+,\/:;<=>?@[\]\^`{|}~]\+\(\s\|;\|$\)\@=/
syn match       zoneDomain      contained  /[^[:space:]!"#$%&'()*+,\/:;<=>?@[\]\^`{|}~]\+\(\s\|;\|$\)\@=/

syn match       zoneSpecial     contained /^[@*.]\s/
syn match       zoneTTL         contained /\<\d[0-9HhWwDd]*\>/  nextgroup=zoneClass,zoneRRType skipwhite
syn keyword     zoneClass       contained IN CHAOS              nextgroup=zoneRRType,zoneTTL   skipwhite
"added zoneOriginSym to match a singular @ for cnames, added SPF rrtype
syn keyword     zoneRRType      contained A AAAA CNAME HINFO MX NS PTR SOA SPF SRV TXT nextgroup=zoneRData skipwhite
syn match       zoneRData       contained /[^;]*/ contains=zoneDomain,zoneIPAddr,zoneIP6Addr,zoneText,zoneNumber,zoneParen,zoneOriginSym,zoneUnknown

syn match       zoneIPAddr      contained /\<[0-9]\{1,3}\(\.[0-9]\{1,3}\)\{,3}\>/

"   Plain IPv6 address          IPv6-embedded-IPv4 address
"   1111:2:3:4:5:6:7:8          1111:2:3:4:5:6:127.0.0.1
syn match       zoneIP6Addr     contained /\<\(\x\{1,4}:\)\{6}\(\x\{1,4}:\x\{1,4}\|\([0-2]\?\d\{1,2}\.\)\{3}[0-2]\?\d\{1,2}\)\>/
"   ::[...:]8                   ::[...:]127.0.0.1
syn match       zoneIP6Addr     contained /\s\@<=::\(\(\x\{1,4}:\)\{,6}\x\{1,4}\|\(\x\{1,4}:\)\{,5}\([0-2]\?\d\{1,2}\.\)\{3}[0-2]\?\d\{1,2}\)\>/
"   1111::[...:]8               1111::[...:]127.0.0.1
syn match       zoneIP6Addr     contained /\<\(\x\{1,4}:\)\{1}:\(\(\x\{1,4}:\)\{,5}\x\{1,4}\|\(\x\{1,4}:\)\{,4}\([0-2]\?\d\{1,2}\.\)\{3}[0-2]\?\d\{1,2}\)\>/
"   1111:2::[...:]8             1111:2::[...:]127.0.0.1
syn match       zoneIP6Addr     contained /\<\(\x\{1,4}:\)\{2}:\(\(\x\{1,4}:\)\{,4}\x\{1,4}\|\(\x\{1,4}:\)\{,3}\([0-2]\?\d\{1,2}\.\)\{3}[0-2]\?\d\{1,2}\)\>/
"   1111:2:3::[...:]8           1111:2:3::[...:]127.0.0.1
syn match       zoneIP6Addr     contained /\<\(\x\{1,4}:\)\{3}:\(\(\x\{1,4}:\)\{,3}\x\{1,4}\|\(\x\{1,4}:\)\{,2}\([0-2]\?\d\{1,2}\.\)\{3}[0-2]\?\d\{1,2}\)\>/
"   1111:2:3:4::[...:]8         1111:2:3:4::[...:]127.0.0.1
syn match       zoneIP6Addr     contained /\<\(\x\{1,4}:\)\{4}:\(\(\x\{1,4}:\)\{,2}\x\{1,4}\|\(\x\{1,4}:\)\{,1}\([0-2]\?\d\{1,2}\.\)\{3}[0-2]\?\d\{1,2}\)\>/
"   1111:2:3:4:5::[...:]8       1111:2:3:4:5::127.0.0.1
syn match       zoneIP6Addr     contained /\<\(\x\{1,4}:\)\{5}:\(\(\x\{1,4}:\)\{,1}\x\{1,4}\|\([0-2]\?\d\{1,2}\.\)\{3}[0-2]\?\d\{1,2}\)\>/
"   1111:2:3:4:5:6::8           -
syn match       zoneIP6Addr     contained /\<\(\x\{1,4}:\)\{6}:\x\{1,4}\>/
"   1111[:...]::                -
syn match       zoneIP6Addr     contained /\<\(\x\{1,4}:\)\{1,7}:\(\s\|;\|$\)\@=/
"edited to allow for more than one string in a TXT record, required for thing like DKIM
syn match       zoneText        contained /\("\([^"\\]\|\\.\)*" \?\)\{0,5}\(\s\|;\|$\)\@=/
" added to fix CNAME intolerance of @
syn match		zoneOriginSym	contained /@\(\s\|;\|$\)\@=/
syn match       zoneNumber      contained /\<[0-9]\+\(\s\|;\|$\)\@=/
syn match       zoneSerial      contained /\<[0-9]\{9,10}\(\s\|;\|$\)\@=/

syn match       zoneErrParen    /)/
syn region      zoneParen       contained start="(" end=")" contains=zoneSerial,zoneNumber,zoneComment
syn match       zoneComment     /;.*/

" Define the default highlighting.
" For version 5.7 and earlier: only when not done already
" For version 5.8 and later: only when an item doesn't have highlighting yet
if version >= 508 || !exists("did_bind_zone_syn_inits")
  if version < 508
    let did_bind_zone_syn_inits = 1
    command -nargs=+ HiLink hi link <args>
  else
    command -nargs=+ HiLink hi def link <args>
  endif

  HiLink zoneDirective    Macro

  HiLink zoneUnknown      Error

  HiLink zoneOrigin       Statement
  HiLink zoneOwnerName    Statement
  HiLink zoneDomain       Identifier

  HiLink zoneSpecial      Special
  HiLink zoneTTL          Constant
  HiLink zoneClass        Include
  HiLink zoneRRType       Type

  HiLink zoneIPAddr       Number
  HiLink zoneIP6Addr      Number
  HiLink zoneText         String
  HiLink zoneNumber       Number
  HiLink zoneSerial       Number "Changed from special to number because why.
  HiLink zoneOriginSym    String

  HiLink zoneErrParen     Error
  HiLink zoneComment      Comment

  delcommand HiLink
endif

let b:current_syntax = "bindzone"

" vim:sts=2 sw=2