Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FFB582488;
	Sat, 28 Sep 2024 20:50:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727556613; cv=none; b=livMn5ZHzVlml6ARafczCK2xXs8m2ALwLCBoATnBu5mno830Zre5tl4LOnwSwizUNwBI7Apt2sWxlPL57yR/nhfze8yVzXLhzGwpZdqgG6dZprmIGuUHC//yZRHb8EJts7iHiLdjVG9p6a0BWQq+poCj6qAG44yAbl5ncWIwSvI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727556613; c=relaxed/simple;
	bh=tqrJfTagSD9ASCMw/rWjbwkeTeJS5HaIzmdi+hT16ng=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FlKdCwioDTqT+LA1PYjCSP2UvCQEEC42aJTUD5yMB1A1/7B18dtjbjH+9+vuiXMUcPrAK7rg6JJcY/y0W5MX3jqM9FX/MFTQzKVGauhBjjT+FJBtehZ2HdAvJu/QoaVTobaiXO1bnhDByxNIKuSiOUrnFPeanJBcW3pYMICasuI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=H9G4eZ8w; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="H9G4eZ8w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD624C4CEC3;
	Sat, 28 Sep 2024 20:50:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1727556612;
	bh=tqrJfTagSD9ASCMw/rWjbwkeTeJS5HaIzmdi+hT16ng=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=H9G4eZ8wL25Bno0Nr4zkq9qWOPc47iuo7FrB75xBzudLYiliNy0IjTnvZs5hruxOd
	 USBw1LW/p5I1QPm8C/SGbwV/BgP1OHmI0lpGCZ862n4rt7tCmwd5dud0/BOnaAxSLF
	 Rum+v1BGWSQe72V2N+oodjV2V+pxJg102SROa7dR81vpLOLQ3sBpNOtCMBci24QdF/
	 7yVqrKXxYkUV2OfsJfRpp2hTcSTL24/V2emrkbySZHgeK+VryRx4r0dcFPdD0gomWZ
	 n7ZrOY5P8eeXyVs34D+UXW5jCyXKhZOKD+1Kor+ZWULfPE2jle1/MJ4+xwSVI9SmqK
	 zpu7PrvLe3VHw==
Date: Sat, 28 Sep 2024 13:50:12 -0700
From: Kees Cook <kees@kernel.org>
To: Bill Wendling <morbo@google.com>
Cc: Ard Biesheuvel <ardb@kernel.org>, Jan Hendrik Farr <kernel@jfarr.cc>,
	Thorsten Blum <thorsten.blum@toblux.com>, kent.overstreet@linux.dev,
	regressions@lists.linux.dev, linux-bcachefs@vger.kernel.org,
	linux-hardening@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [REGRESSION][BISECTED] erroneous buffer overflow detected in
 bch2_xattr_validate
Message-ID: <202409281335.5EE231B9C7@keescook>
References: <ZvV6X5FPBBW7CO1f@archlinux>
 <3E304FB2-799D-478F-889A-CDFC1A52DCD8@toblux.com>
 <A499F119-5F0C-43FC-9058-7AB92057F9B3@toblux.com>
 <ZvWTXaqkmxP2E2dc@archlinux>
 <ZvWd0aK7p_1rkb7E@archlinux>
 <CAMj1kXFV+Jck9Yf4w18rOzHckXvpXkhPhL-KrpBC8hqgXusw2g@mail.gmail.com>
 <CAGG=3QXG+Vsm7mjLV42Q-uA-EvgfOehSUeNQjKA3QQbw8vqSCg@mail.gmail.com>
 <CAGG=3QVWCQB-3sM=iwgTmX8zrU81H+F_A1icJwROvW_DSvsBeA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAGG=3QVWCQB-3sM=iwgTmX8zrU81H+F_A1icJwROvW_DSvsBeA@mail.gmail.com>

On Thu, Sep 26, 2024 at 06:30:15PM -0700, Bill Wendling wrote:
> On Thu, Sep 26, 2024 at 3:18 PM Bill Wendling <morbo@google.com> wrote:
> >
> > On Thu, Sep 26, 2024 at 12:58 PM Ard Biesheuvel <ardb@kernel.org> wrote:
> > >
> > > (cc Kees and Bill)
> > >
> > > On Thu, 26 Sept 2024 at 19:46, Jan Hendrik Farr <kernel@jfarr.cc> wrote:
> > > >
> > > > On 26 19:01:20, Jan Hendrik Farr wrote:
> > > > > On 26 18:09:57, Thorsten Blum wrote:
> > > > > > On 26. Sep 2024, at 17:28, Thorsten Blum <thorsten.blum@toblux.com> wrote:
> > > > > > > On 26. Sep 2024, at 17:14, Jan Hendrik Farr <kernel@jfarr.cc> wrote:
> [...]
> > > > > > >> [    6.252375] memchr: detected buffer overflow: 12 byte read of buffer size 0
> [...]
> > > > >       bkey_fsck_err_on(memchr(xattr.v->x_name, '\0', xattr.v->x_name_len),
> > > > >                        c, xattr_name_invalid_chars,
> > > > >                        "xattr name has invalid characters");
> [...]

The thing going wrong is that __bdos(xattr.v->x_name, 0) is returning 0.
This looks exactly like the bug I minimized here:
https://lore.kernel.org/all/202409170436.C3C6E7F7A@keescook/

Since there wasn't an LLVM open bug yet, I've created:
https://github.com/llvm/llvm-project/issues/110385

-Kees

-- 
Kees Cook
