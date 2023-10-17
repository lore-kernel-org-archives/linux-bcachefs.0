Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 998A3CDB474
	for <linux-bcachefs@archiver.kernel.org>; Tue, 17 Oct 2023 14:12:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343675AbjJQOMY (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Tue, 17 Oct 2023 10:12:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343584AbjJQOMY (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Tue, 17 Oct 2023 10:12:24 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEA28FC
        for <linux-bcachefs@vger.kernel.org>; Tue, 17 Oct 2023 07:11:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1697551902;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=PWjusTAfFAOYOcD/DhpPcW94Ds/LtAztiDTrje2s98g=;
        b=HVznYd2Sn8qO0HMHZtzofZNZIWrKMBJuLSV0z+7jzm4BoNvwoUshQOQYn8pSUm37udiI/7
        lBXyaTznTXnH2Jy+ck5THH6ikxd6iYHtlwKeVQLmvzgFCCNpRQyG3sgMsl5XVJsgYBf0UU
        XAo6SQMHa7RVz2CNRzW7nXV7e6sX4cA=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-438-qPTiZEUSNaWokVxo9Zq7Ww-1; Tue, 17 Oct 2023 10:11:41 -0400
X-MC-Unique: qPTiZEUSNaWokVxo9Zq7Ww-1
Received: by mail-qv1-f69.google.com with SMTP id 6a1803df08f44-66d75988385so3554156d6.2
        for <linux-bcachefs@vger.kernel.org>; Tue, 17 Oct 2023 07:11:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697551900; x=1698156700;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PWjusTAfFAOYOcD/DhpPcW94Ds/LtAztiDTrje2s98g=;
        b=hYAtXtW3R78Vn92quMA9p3MKoXOFo50b3jQ78RmAPBAer1AItgJveAn8nAlkvEEUqA
         oy4banxf2bFyvX/COfq6mxyVWjUzJDhluHtqLLPGvsA6c2R7xf0LA0lcbcAiOvl4RUJi
         FnsHy8tYGLz4Qa2ZXRTT0WLtPrtksg2D7HSqYYJbV/mJkUafcZhZ32h3xKL6v2RMQzHv
         SEQkXUn+8Yr64b8iDtkf14BT+Sg/S9oBi2BOBBTLthD+nw/aTFv4nBqSmT9F+MckNPwn
         QsdGn5NhcPlQ0L3ktn43oECncy1O+yKIM6J59/WEtCSm1Dsa7gk2gTBjkTg07hGZNooQ
         VXug==
X-Gm-Message-State: AOJu0YwJbmOXN0levxzIb05uNutc05TeiXfP19V7SpcblwqblJV/E5HV
        OhrPind6XsVIpSKBokZchLR2tSQEZhNzHXTQaY3LYSd41nJjHHqlvu/fx+646X6eQJP0CEgzLfJ
        FZXQpN1FVJvsnv7UL7nqjxC9GTh0QfpeTT+o=
X-Received: by 2002:a05:6214:da7:b0:66d:6667:deab with SMTP id h7-20020a0562140da700b0066d6667deabmr2987440qvh.35.1697551900038;
        Tue, 17 Oct 2023 07:11:40 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHaov+EHfdufc+0uU9wJyHBemkRgREA1JH9A+Yv3c96V2jcir7c3rBMBtVmswOhzo5W96Xjnw==
X-Received: by 2002:a05:6214:da7:b0:66d:6667:deab with SMTP id h7-20020a0562140da700b0066d6667deabmr2987415qvh.35.1697551899738;
        Tue, 17 Oct 2023 07:11:39 -0700 (PDT)
Received: from bfoster (c-24-60-61-41.hsd1.ma.comcast.net. [24.60.61.41])
        by smtp.gmail.com with ESMTPSA id dl8-20020ad44e08000000b006577e289d37sm583566qvb.2.2023.10.17.07.11.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Oct 2023 07:11:39 -0700 (PDT)
Date:   Tue, 17 Oct 2023 10:12:05 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Kees Cook <keescook@chromium.org>
Cc:     Kent Overstreet <kent.overstreet@linux.dev>,
        linux-bcachefs@vger.kernel.org, kernel test robot <lkp@intel.com>,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
Subject: Re: [PATCH] bcachefs: Refactor bkey_i to use a flexible array
Message-ID: <ZS6WNXABUDTh8NZA@bfoster>
References: <20231010235609.work.594-kees@kernel.org>
 <ZSkpU0vdrCTfTxuZ@bfoster>
 <202310131637.D0C66BFBA@keescook>
 <ZS0vlpSwH1+/+EVM@bfoster>
 <202310161249.43FB42A6@keescook>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202310161249.43FB42A6@keescook>
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

On Mon, Oct 16, 2023 at 02:18:19PM -0700, Kees Cook wrote:
> On Mon, Oct 16, 2023 at 08:41:58AM -0400, Brian Foster wrote:
> > On Fri, Oct 13, 2023 at 04:44:21PM -0700, Kees Cook wrote:
> > > On Fri, Oct 13, 2023 at 07:26:11AM -0400, Brian Foster wrote:
> > > > On Tue, Oct 10, 2023 at 04:56:12PM -0700, Kees Cook wrote:
...
> > > > 
> > > > Hi Kees,
> > > > 
> > > > I'm curious if this is something that could be buried in bch_val given
> > > > it's already kind of a fake structure..? If not, my only nitty comment
> > > 
> > > I was thinking it would be best to keep the flexible array has "high" in
> > > the struct as possible, as in the future more refactoring will be needed
> > > to avoid having flex arrays overlap with other members in composite
> > > structures. So instead of pushing into bch_val, I left it at the highest
> > > level possible, bch_i, as that's the struct being used by the memcpy().
> > > 
> > > Eventually proper unions will be needed instead of overlapping bch_i
> > > with other types, as in:
> > > 
> > > struct btree_root {
> > >         struct btree            *b;
> > > 
> > >         /* On disk root - see async splits: */
> > >         __BKEY_PADDED(key, BKEY_BTREE_PTR_VAL_U64s_MAX);
> > >         u8                      level;
> > >         u8                      alive;
> > >         s8                      error;
> > > };
> > > 
> > > But that's all for the future. Right now I wanted to deal with the more
> > > pressing matter of a 0-sized array not being zero sized. :)
> > > 
> > 
> > Ok, but I'm not really following how one approach vs. the other relates
> > to this particular example of an embedded bkey_i. I'm probably just not
> > familiar enough with the current issues with 0-sized arrays and the
> > anticipated path forward. Can you elaborate for somebody who is more
> > focused on trying to manage the design/complexity of these various key
> > data structures? For example, what's the practical difference here (for
> > future work) if the flex array lives in bch_val vs. bkey_i?
> 
> I was looking strictly at the layer it was happening: the function that
> calls memcpy() is working on a bkey_i, so I figured that was the place
> for it currently.
> 
> > Note that I don't necessarily have a strong opinion on this atm, but if
> > there's a "for future reasons" aspect to this approach I'd like to at
> > least understand it a little better. ;)
> 
> The future work here is about making sure flexible arrays don't overlap
> with non-flexible array members[1], and that will require giving some
> thought to how the structures are arranged.
> 
...
> The use of "struct header" effectively says "we have some number of bytes,
> but we don't know *what* it is yet". Is it cmd_one, or cmd_two? Instead
> of combining the flex array with the header, we can either split it off:
> 
> struct header {
> 	u32 long flags;
> 	struct other things;
> 	size_t byte_count;
> };
> 
> struct cmd_unknown {
> 	struct header;
> 	u8 bytes[];
> };
> 
> Or we can merge all the structs together:
> 
> struct everything {
> 	u32 long flags;
> 	struct other things;
> 	size_t byte_count;
> 	union {
> 		struct cmd_one {
> 			u64 detail;
> 			u8 bits;
> 		};
> 		struct cmd_two {
> 			u32 foo, bar;
> 			u64 baz;
> 		};
> 		struct unknown {
> 			u8 bytes[];
> 		};
> 	};
> };
> 
> In the first style, the flexible array is distinctly separate. In the
> second style the overlap is explicitly shown via the union.
> 
> I expect it will take a long time to make the kernel "flex array overlap
> clean", so while I don't feel any rush, I've been generally trying to
> avoid seeing new instances of ambiguous overlap _added_ to the kernel. :)
> 

Got it. This helps explain potential wonkiness of a variant with the
flex array buried in bch_val.

> bcachefs is in a unique places where because it's been out of tree
> its code patterns aren't "new", but it's just been "added" upstream.
> *shrug* So we'll deal with the existing warnings we've already got,
> and prepare for the future warnings as we can.
> 

Ack.

> Hopefully that helps!
> 

Indeed it does, thanks!

Brian

> -Kees
> 
> [1] See "-Wflex-array-member-not-at-end":
>     https://gcc.gnu.org/onlinedocs/gcc/Zero-Length.html
> [2] Going all the way back to 76497732932f ("cxgb3/l2t: Fix undefined behaviour")
> 
> > 
> > > > is that memcpy(k->bytes[], ...) makes it kind of read like we're copying
> > > > in opaque key data rather than value data, so perhaps a slightly more
> > > > descriptive field name would be helpful. But regardless I'd wait until
> > > > Kent has a chance to comment before changing anything..
> > > 
> > > How about "v_bytes" instead of "bytes"? Or if it really is preferred,
> > > I can move the flex array into bch_val -- it just seems like the wrong
> > > layer...
> > > 
> > 
> > Yeah.. v_bytes, value_bytes, etc. etc. Anything that avoids misleading
> > code when using the field is good with me. Thanks.
> > 
> > Brian
> > 
> > > -Kees
> > > 
> > > > 
> > > > Brian
> > > > 
> > > > >  
> > > > >  #define KEY(_inode, _offset, _size)					\
> > > > > diff --git a/fs/bcachefs/extents.h b/fs/bcachefs/extents.h
> > > > > index 7ee8d031bb6c..6248e17bbac5 100644
> > > > > --- a/fs/bcachefs/extents.h
> > > > > +++ b/fs/bcachefs/extents.h
> > > > > @@ -642,7 +642,7 @@ static inline void bch2_bkey_append_ptr(struct bkey_i *k, struct bch_extent_ptr
> > > > >  
> > > > >  		ptr.type = 1 << BCH_EXTENT_ENTRY_ptr;
> > > > >  
> > > > > -		memcpy((void *) &k->v + bkey_val_bytes(&k->k),
> > > > > +		memcpy(&k->bytes[bkey_val_bytes(&k->k)],
> > > > >  		       &ptr,
> > > > >  		       sizeof(ptr));
> > > > >  		k->k.u64s++;
> > > > > -- 
> > > > > 2.34.1
> > > > > 
> > > > 
> > > 
> > > -- 
> > > Kees Cook
> > > 
> > 
> 
> -- 
> Kees Cook
> 

