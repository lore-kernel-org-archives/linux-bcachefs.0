Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C003CDB465
	for <linux-bcachefs@archiver.kernel.org>; Mon, 16 Oct 2023 21:18:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232046AbjJPVSX (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Mon, 16 Oct 2023 17:18:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229666AbjJPVSW (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Mon, 16 Oct 2023 17:18:22 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6613A7
        for <linux-bcachefs@vger.kernel.org>; Mon, 16 Oct 2023 14:18:20 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id d2e1a72fcca58-6b9af7d41d2so1866909b3a.0
        for <linux-bcachefs@vger.kernel.org>; Mon, 16 Oct 2023 14:18:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1697491100; x=1698095900; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=dadSSBc4th7Oq3HrYctNHxDRHsr2TvRZmUPJ29Jh97s=;
        b=WeuRguorXF4GlUT15IuXIR8oumwTP3cQFpKsjP8mTjT/1fBzrzentsmfL2yYMkqYHQ
         yA98qTyTsN24InwfCAP/3jSh8BKg8pdXEsiV5qRQurFzJLRo7W1eIO3gcYAJuvzaYGnR
         QCSRSDq6y6hKALnf6KDyvXOlYqs+pn6qOrJuA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697491100; x=1698095900;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dadSSBc4th7Oq3HrYctNHxDRHsr2TvRZmUPJ29Jh97s=;
        b=FWfX6Rq1j2V7DVCxDnhiTPCwtBUiD+832AckOJqZFCtc86WkMcFtg3SM2GmPlf8MPc
         xKa9bC6Ay91dUIkJqBFQ5wUzXD4dvzTFkH08iGWx9P15Mnasg3sieEIDrTjbbkAB55uu
         OU6fCX+JYyEiDLcSDgDMWSyhW927YS7yBmdk3MvyC/BtOO1ZllKcdr/FFqBJLTgsHjzM
         +13hG2nveSwUxjUQdeAKuQYwzDYrgcVJYEzo+dooTSL5ylZJZ0n/8kEKjHlQyVYwczS5
         pJTFtqlKGBOMmnJ4WstO0b9tJ7YB8m0etOLgQqncPKMMtmbjb2ftBsiRrq/61pEaIEGr
         v46w==
X-Gm-Message-State: AOJu0YwsxJ8jV7O+2SytLlPQfQAlMbwwblpTZ5RhaTMfOMmE+o2suTq/
        KwIrzc49+ZmCYnad1ncUQMc6tw==
X-Google-Smtp-Source: AGHT+IHX1JuAZP7QjOOnXjPpL0JNyaDoeed5AbFBNbQHP3sAultOKIbHZ4eoTJA93ArTK4NBzJHzew==
X-Received: by 2002:a05:6a00:1887:b0:691:2d4:23a2 with SMTP id x7-20020a056a00188700b0069102d423a2mr324434pfh.31.1697491100331;
        Mon, 16 Oct 2023 14:18:20 -0700 (PDT)
Received: from www.outflux.net (198-0-35-241-static.hfc.comcastbusiness.net. [198.0.35.241])
        by smtp.gmail.com with ESMTPSA id n10-20020a63590a000000b0057a868900a9sm73977pgb.67.2023.10.16.14.18.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Oct 2023 14:18:19 -0700 (PDT)
Date:   Mon, 16 Oct 2023 14:18:19 -0700
From:   Kees Cook <keescook@chromium.org>
To:     Brian Foster <bfoster@redhat.com>
Cc:     Kent Overstreet <kent.overstreet@linux.dev>,
        linux-bcachefs@vger.kernel.org, kernel test robot <lkp@intel.com>,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
Subject: Re: [PATCH] bcachefs: Refactor bkey_i to use a flexible array
Message-ID: <202310161249.43FB42A6@keescook>
References: <20231010235609.work.594-kees@kernel.org>
 <ZSkpU0vdrCTfTxuZ@bfoster>
 <202310131637.D0C66BFBA@keescook>
 <ZS0vlpSwH1+/+EVM@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZS0vlpSwH1+/+EVM@bfoster>
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

On Mon, Oct 16, 2023 at 08:41:58AM -0400, Brian Foster wrote:
> On Fri, Oct 13, 2023 at 04:44:21PM -0700, Kees Cook wrote:
> > On Fri, Oct 13, 2023 at 07:26:11AM -0400, Brian Foster wrote:
> > > On Tue, Oct 10, 2023 at 04:56:12PM -0700, Kees Cook wrote:
> > > > The memcpy() in bch2_bkey_append_ptr() is operating on an embedded
> > > > fake flexible array. Instead, make it explicit, and convert the memcpy
> > > > to target the flexible array instead. Fixes the W=1 warning seen for
> > > > -Wstringop-overflow:
> > > > 
> > > >    In file included from include/linux/string.h:254,
> > > >                     from include/linux/bitmap.h:11,
> > > >                     from include/linux/cpumask.h:12,
> > > >                     from include/linux/smp.h:13,
> > > >                     from include/linux/lockdep.h:14,
> > > >                     from include/linux/radix-tree.h:14,
> > > >                     from include/linux/backing-dev-defs.h:6,
> > > >                     from fs/bcachefs/bcachefs.h:182:
> > > >    fs/bcachefs/extents.c: In function 'bch2_bkey_append_ptr':
> > > >    include/linux/fortify-string.h:57:33: warning: writing 8 bytes into a region of size 0 [-Wstringop-overflow=]
> > > >       57 | #define __underlying_memcpy     __builtin_memcpy
> > > >          |                                 ^
> > > >    include/linux/fortify-string.h:648:9: note: in expansion of macro '__underlying_memcpy'
> > > >      648 |         __underlying_##op(p, q, __fortify_size);                        \
> > > >          |         ^~~~~~~~~~~~~
> > > >    include/linux/fortify-string.h:693:26: note: in expansion of macro '__fortify_memcpy_chk'
> > > >      693 | #define memcpy(p, q, s)  __fortify_memcpy_chk(p, q, s,                  \
> > > >          |                          ^~~~~~~~~~~~~~~~~~~~
> > > >    fs/bcachefs/extents.c:235:17: note: in expansion of macro 'memcpy'
> > > >      235 |                 memcpy((void *) &k->v + bkey_val_bytes(&k->k),
> > > >          |                 ^~~~~~
> > > >    fs/bcachefs/bcachefs_format.h:287:33: note: destination object 'v' of size 0
> > > >      287 |                 struct bch_val  v;
> > > >          |                                 ^
> > > > 
> > > > Cc: Kent Overstreet <kent.overstreet@linux.dev>
> > > > Cc: Brian Foster <bfoster@redhat.com>
> > > > Cc: linux-bcachefs@vger.kernel.org
> > > > Reported-by: kernel test robot <lkp@intel.com>
> > > > Closes: https://lore.kernel.org/oe-kbuild-all/202309192314.VBsjiIm5-lkp@intel.com/
> > > > Signed-off-by: Kees Cook <keescook@chromium.org>
> > > > ---
> > > >  fs/bcachefs/bcachefs_format.h | 5 ++++-
> > > >  fs/bcachefs/extents.h         | 2 +-
> > > >  2 files changed, 5 insertions(+), 2 deletions(-)
> > > > 
> > > > diff --git a/fs/bcachefs/bcachefs_format.h b/fs/bcachefs/bcachefs_format.h
> > > > index f0d130440baa..f5e8cb43697b 100644
> > > > --- a/fs/bcachefs/bcachefs_format.h
> > > > +++ b/fs/bcachefs/bcachefs_format.h
> > > > @@ -300,7 +300,10 @@ struct bkey_i {
> > > >  	__u64			_data[0];
> > > >  
> > > >  	struct bkey	k;
> > > > -	struct bch_val	v;
> > > > +	union {
> > > > +		struct bch_val	v;
> > > > +		DECLARE_FLEX_ARRAY(__u8, bytes);
> > > > +	};
> > > >  };
> > > 
> > > Hi Kees,
> > > 
> > > I'm curious if this is something that could be buried in bch_val given
> > > it's already kind of a fake structure..? If not, my only nitty comment
> > 
> > I was thinking it would be best to keep the flexible array has "high" in
> > the struct as possible, as in the future more refactoring will be needed
> > to avoid having flex arrays overlap with other members in composite
> > structures. So instead of pushing into bch_val, I left it at the highest
> > level possible, bch_i, as that's the struct being used by the memcpy().
> > 
> > Eventually proper unions will be needed instead of overlapping bch_i
> > with other types, as in:
> > 
> > struct btree_root {
> >         struct btree            *b;
> > 
> >         /* On disk root - see async splits: */
> >         __BKEY_PADDED(key, BKEY_BTREE_PTR_VAL_U64s_MAX);
> >         u8                      level;
> >         u8                      alive;
> >         s8                      error;
> > };
> > 
> > But that's all for the future. Right now I wanted to deal with the more
> > pressing matter of a 0-sized array not being zero sized. :)
> > 
> 
> Ok, but I'm not really following how one approach vs. the other relates
> to this particular example of an embedded bkey_i. I'm probably just not
> familiar enough with the current issues with 0-sized arrays and the
> anticipated path forward. Can you elaborate for somebody who is more
> focused on trying to manage the design/complexity of these various key
> data structures? For example, what's the practical difference here (for
> future work) if the flex array lives in bch_val vs. bkey_i?

I was looking strictly at the layer it was happening: the function that
calls memcpy() is working on a bkey_i, so I figured that was the place
for it currently.

> Note that I don't necessarily have a strong opinion on this atm, but if
> there's a "for future reasons" aspect to this approach I'd like to at
> least understand it a little better. ;)

The future work here is about making sure flexible arrays don't overlap
with non-flexible array members[1], and that will require giving some
thought to how the structures are arranged.

The specific "problem" being solved is the ambiguity in the C language
for dealing with flexible arrays. For example, this will already throw a
warning:

struct whoops {
	u32 stuff;
	u8 how_many_shorts;
	u16 shorts[];
	u64 flags;
};

Doing struct_size()-style allocations will end up with a clobbered
"flags" member when accessing the first 4 "shorts", etc. This neighboring
overwrite corruption code pattern has happened (and been fixed) a bunch[2]
in the kernel when someone adds a new member to a struct at the end
without noticing the flexible array. (In the past, it was usually via
the 0-sized arrays, e.g. "u16 shorts[0]".) One of the many benefits of
using C99 flex arrays is that the compiler will warn now (when it's in
the same struct), and "flags" can be moved to the right place, etc.

*However*, the compiler wasn't warning about composite structures, like
this:

struct inner {
	u32 stuff;
	u8 how_many_shorts;
	u16 shorts[];
};

struct whoops {
	struct inner instance;
	u64 flags;
};

This ends up being an ambiguous situation: is "flags" an interpretation
of the first 4 "shorts", or is it an accidental overlap that will lead
to memory corruption? So, in our ongoing battle to eliminate ambiguities
in the codebase, we've moving away from this code pattern (with the
help of the future -Wflex-array-member-not-at-end compiler option),
by switching to unambiguous structure layouts.

The common "intentional overlap" use-case is very similar to the bcachefs
code. For example:

struct header {
	u32 long flags;
	struct other things;
	size_t byte_count;
	u8 bytes[];
};

struct cmd_one {
	struct header hdr;
	u64 detail;
	u8 bits;
};

struct cmd_two {
	struct header hdr;
	u32 foo, bar;
	u64 baz;
};

The use of "struct header" effectively says "we have some number of bytes,
but we don't know *what* it is yet". Is it cmd_one, or cmd_two? Instead
of combining the flex array with the header, we can either split it off:

struct header {
	u32 long flags;
	struct other things;
	size_t byte_count;
};

struct cmd_unknown {
	struct header;
	u8 bytes[];
};

Or we can merge all the structs together:

struct everything {
	u32 long flags;
	struct other things;
	size_t byte_count;
	union {
		struct cmd_one {
			u64 detail;
			u8 bits;
		};
		struct cmd_two {
			u32 foo, bar;
			u64 baz;
		};
		struct unknown {
			u8 bytes[];
		};
	};
};

In the first style, the flexible array is distinctly separate. In the
second style the overlap is explicitly shown via the union.

I expect it will take a long time to make the kernel "flex array overlap
clean", so while I don't feel any rush, I've been generally trying to
avoid seeing new instances of ambiguous overlap _added_ to the kernel. :)

bcachefs is in a unique places where because it's been out of tree
its code patterns aren't "new", but it's just been "added" upstream.
*shrug* So we'll deal with the existing warnings we've already got,
and prepare for the future warnings as we can.

Hopefully that helps!

-Kees

[1] See "-Wflex-array-member-not-at-end":
    https://gcc.gnu.org/onlinedocs/gcc/Zero-Length.html
[2] Going all the way back to 76497732932f ("cxgb3/l2t: Fix undefined behaviour")

> 
> > > is that memcpy(k->bytes[], ...) makes it kind of read like we're copying
> > > in opaque key data rather than value data, so perhaps a slightly more
> > > descriptive field name would be helpful. But regardless I'd wait until
> > > Kent has a chance to comment before changing anything..
> > 
> > How about "v_bytes" instead of "bytes"? Or if it really is preferred,
> > I can move the flex array into bch_val -- it just seems like the wrong
> > layer...
> > 
> 
> Yeah.. v_bytes, value_bytes, etc. etc. Anything that avoids misleading
> code when using the field is good with me. Thanks.
> 
> Brian
> 
> > -Kees
> > 
> > > 
> > > Brian
> > > 
> > > >  
> > > >  #define KEY(_inode, _offset, _size)					\
> > > > diff --git a/fs/bcachefs/extents.h b/fs/bcachefs/extents.h
> > > > index 7ee8d031bb6c..6248e17bbac5 100644
> > > > --- a/fs/bcachefs/extents.h
> > > > +++ b/fs/bcachefs/extents.h
> > > > @@ -642,7 +642,7 @@ static inline void bch2_bkey_append_ptr(struct bkey_i *k, struct bch_extent_ptr
> > > >  
> > > >  		ptr.type = 1 << BCH_EXTENT_ENTRY_ptr;
> > > >  
> > > > -		memcpy((void *) &k->v + bkey_val_bytes(&k->k),
> > > > +		memcpy(&k->bytes[bkey_val_bytes(&k->k)],
> > > >  		       &ptr,
> > > >  		       sizeof(ptr));
> > > >  		k->k.u64s++;
> > > > -- 
> > > > 2.34.1
> > > > 
> > > 
> > 
> > -- 
> > Kees Cook
> > 
> 

-- 
Kees Cook
