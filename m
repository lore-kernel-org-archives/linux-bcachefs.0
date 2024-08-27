Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F3E81C688E
	for <linux-bcachefs@vger.kernel.org>; Tue, 27 Aug 2024 18:26:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724783164; cv=none; b=UrWk3RH73/XGmm606UCPmpiwj/+UvMCkLQAPN6vYe/Bfip/86AYCyKQPAiwYDWnXAaOb+TMvuo2Mvx57e6/w1ondJc2bkvZrMPh6F+IqW3JiCC4u1bOBOzF6p9moQOKeXfFR0/7e/1kWlioJznWoHBZRWKqoq7PYAj8oOFdBSdA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724783164; c=relaxed/simple;
	bh=nxcMUPkBKykb3i5RJjQJ5czkCAct+wxS2Ut+p+S66Ek=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pE2fh1xe0fJO98c7jdxUi5AwwbJRzACybMhPxfz6k+mJWo38hjK6aRQL184ZCeBdrx1wqyoKsMVjo8ENVBVWr4RVC4234Lo83+mbTpWEkkZTp/UoMWNLwUvBlnR8ngFeLXbDnQ75fmYbNMlXrbwkUzLNlUPSq8OfMRZ/y6uqfyw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=eG0lNHWj; arc=none smtp.client-ip=209.85.221.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="eG0lNHWj"
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-37196229343so3597711f8f.0
        for <linux-bcachefs@vger.kernel.org>; Tue, 27 Aug 2024 11:26:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1724783161; x=1725387961; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=taToXkOoFI4dvSDRErd9uMqfnQgFfJ+8kZ6b29LeX7w=;
        b=eG0lNHWj6O0ShOFvp61MEY1/u6bUy/AH4hMo6vOnc7qF/9vu/o5g7Ts9xKes68u3OU
         c1VhWq3GnImef/X0dTpY6eNRDxf6ZT2OESI0hJU9sLMCCODydgJE7Kk1YWUn9QSoXg93
         drzeI35YncCdJmQgpyqbfK0L0u5VtZmaP1l/aAlavpDi9mZfs5CPAyIxjOP645djen2A
         s7n6Fz+ns/WYqxRAr+8H7PzIGOnndmUpDimWrYVEYrkS/9Ob9/y8nvY9HpaYZhsWocEq
         DtlCINkLrJ9pBqYa++3eosorS63CfVikfjYM6xHjQ2oB1KROTknLPs6XxjQtQojBB8gS
         rOzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724783161; x=1725387961;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=taToXkOoFI4dvSDRErd9uMqfnQgFfJ+8kZ6b29LeX7w=;
        b=NOpwdkVanGjz6KB8L/kdesPNeBxUFKKcL6fcmuP0JGgTsc8Iklzu1bJPSNmSCt2XWk
         lA3WjmFK2GJnpr+kUdngGG2TyoPRpWUxrE+A82i3o8uDBg+oiOELnwg+2xHhxrsAl4C6
         LDnFCAT53Cco1gcuejlAtaK5uEfybYvRp+CGy9OM3f48Rsli/drNYX81oMLEc9u4HddL
         LxxhnSdmIYPya0wchqUmSZjg4VHBxMxi7jPqBYNjecpSQZ6+CwWNSOexNxi3+mSm5wdm
         HVbEEOm27Lzb7MATLeWDF+aCuZZCgOW/ZPrXSYd4t2/ashO0vlSNoYA5hRFXPRGqaX0x
         5Pnw==
X-Forwarded-Encrypted: i=1; AJvYcCX44gy1f4IfpGBZDn2GkGVxFe4a9IaTZtrpdCovZFHFV9gJnH/Rz5X6a9HfqmgZoxD0Ds3nAajjM3f1oYC/lA==@vger.kernel.org
X-Gm-Message-State: AOJu0YwXHZC8cqeWdaOvCshtzBNiDX/0MJsI8X3KYuZYTnh23AnI9iSj
	AH/AdhyZ5QxBXWVEcQfSNsFnljhTlYKWkT0xOyi2H/krWMU8rNI9MocrGAuddK4=
X-Google-Smtp-Source: AGHT+IFQ8lUlRu+aDZKavRPPMRony6coPOxIyBtzcUISjTEWst8RDFfV+iVgU1oEURVQjv6ZAhuIGA==
X-Received: by 2002:a05:6000:8:b0:371:7d84:9bef with SMTP id ffacd0b85a97d-3731187d118mr10030791f8f.28.1724783160648;
        Tue, 27 Aug 2024 11:26:00 -0700 (PDT)
Received: from localhost ([196.207.164.177])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3730810fb76sm13842509f8f.8.2024.08.27.11.25.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Aug 2024 11:26:00 -0700 (PDT)
Date: Tue, 27 Aug 2024 21:25:56 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	linux-bcachefs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] bcachefs changes for 6.11, v2
Message-ID: <da03e2a7-0293-4b28-9a08-6c0fad51b9a3@stanley.mountain>
References: <73rweeabpoypzqwyxa7hld7tnkskkaotuo3jjfxnpgn6gg47ly@admkywnz4fsp>
 <d0da8ba5-e73e-454a-bbd7-a4e11886ea8b@stanley.mountain>
 <ltl35vocjtma5an2yo7digcdpcsvf6clrvcd4vdkf67gwabogf@syqzgnw5rodw>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ltl35vocjtma5an2yo7digcdpcsvf6clrvcd4vdkf67gwabogf@syqzgnw5rodw>

On Tue, Aug 27, 2024 at 12:23:22PM -0400, Kent Overstreet wrote:
> On Tue, Aug 27, 2024 at 01:53:55PM GMT, Dan Carpenter wrote:
> > On Thu, Jul 19, 2024 at 06:36:50PM -0400, Kent Overstreet wrote:
> > >       bcachefs: Unlock trans when waiting for user input in fsck
> > 
> > Hello Kent Overstreet,
> > 
> > ommit 889fb3dc5d6f ("bcachefs: Unlock trans when waiting for user
> > input in fsck") from May 29, 2024 (linux-next), leads to the
> > following (UNPUBLISHED) Smatch static checker warning:
> > 
> > fs/bcachefs/error.c:129 bch2_fsck_ask_yn() error: double unlocked 'trans' (orig line 113)
> > 
> > fs/bcachefs/error.c
> >    102  static enum ask_yn bch2_fsck_ask_yn(struct bch_fs *c, struct btree_trans *trans)
> >    103  {
> >    104          struct stdio_redirect *stdio = c->stdio;
> >    105  
> >    106          if (c->stdio_filter && c->stdio_filter != current)
> >    107                  stdio = NULL;
> >    108  
> >    109          if (!stdio)
> >    110                  return YN_NO;
> >    111  
> >    112          if (trans)
> >    113                  bch2_trans_unlock(trans);
> >                         ^^^^^^^^^^^^^^^^^^^^^^^^^
> > Unlock
> > 
> >    114  
> >    115          unsigned long unlock_long_at = trans ? jiffies + HZ * 2 : 0;
> >    116          darray_char line = {};
> >    117          int ret;
> >    118  
> >    119          do {
> >    120                  unsigned long t;
> >    121                  bch2_print(c, " (y,n, or Y,N for all errors of this type) ");
> >    122  rewait:
> >    123                  t = unlock_long_at
> >    124                          ? max_t(long, unlock_long_at - jiffies, 0)
> >    125                          : MAX_SCHEDULE_TIMEOUT;
> >    126  
> >    127                  int r = bch2_stdio_redirect_readline_timeout(stdio, &line, t);
> >    128                  if (r == -ETIME) {
> >    129                          bch2_trans_unlock_long(trans);
> >                                 ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> > Double unlock
> 
> Those are different types of unlocks.
> 

What tripped the static checker up is that bch2_trans_unlock_long() calls
bch2_trans_unlock().

fs/bcachefs/btree_locking.c
   815  void bch2_trans_unlock_long(struct btree_trans *trans)
   816  {
   817          bch2_trans_unlock(trans);
   818          bch2_trans_srcu_unlock(trans);
   819  }

But looking at it now, I guess if we call bch2_trans_unlock() twice the second
unlock is a no-op.  Thanks!

regards,
dan carpenter

