/* Copyright (C) 2001-2020 Artifex Software, Inc.
   All Rights Reserved.

   This software is provided AS-IS with no warranty, either express or
   implied.

   This software is distributed under license and may not be copied,
   modified or distributed except as expressly authorized under the terms
   of the license contained in the file LICENSE in this distribution.

   Refer to licensing information at http://www.artifex.com or contact
   Artifex Software, Inc.,  1305 Grant Avenue - Suite 200, Novato,
   CA 94945, U.S.A., +1(415)492-9861, for further information.
*/


/* Stream wrapper for the AES cypher implementation */
/* Requires scommon.h; strimpl.h if any templates are referenced */

#ifndef saes_INCLUDED
#  define saes_INCLUDED

#include "scommon.h"
#include "aes.h"

/* maximum supported key length in bytes */
#define SAES_MAX_KEYLENGTH 32

/* AES is a symmetric block cipher so we share the stream states.
   The internal cypher state is all held in the ctx pointer */
struct stream_aes_state_s
{
    stream_state_common;	/* a define from scommon.h */
    unsigned char key[SAES_MAX_KEYLENGTH];
    unsigned int keylength;
    unsigned char iv[16];	/* CBC initialization vector */
    int initialized;		/* whether we're set up */
    int use_padding;		/* are we using RFC 1423-style padding? */
    aes_context *ctx;		/* from aes.h */
};

typedef struct stream_aes_state_s stream_aes_state;

int s_aes_set_key(stream_aes_state * state,
                        const unsigned char *key, int keylength);
void s_aes_set_padding(stream_aes_state *state, int use_padding);

/* state declaration macro;
   should be updated for the aes_context finalization */
#define private_st_aes_state()	\
  gs_private_st_ptrs1(st_aes_state, stream_aes_state, "aes filter state",\
  aes_state_enum_ptrs, aes_state_reloc_ptrs, ctx)

extern const stream_template s_aes_template;

/* (de)crypt a section of text in a buffer -- the procedure is the same
 * in each direction. see strimpl.h for return codes.
 */
int s_aes_process_buffer(stream_aes_state *ss, byte *buf, int buf_size);

#endif /* saes_INCLUDED */
