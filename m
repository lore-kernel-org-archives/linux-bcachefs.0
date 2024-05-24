Received: from out-189.mta0.migadu.com (out-189.mta0.migadu.com [91.218.175.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C31C179B7
	for <linux-bcachefs@vger.kernel.org>; Fri, 24 May 2024 17:30:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716571817; cv=none; b=rpxO6oA1fZww8Sr2csJdkT3C2G113OniHhBfZ4GdWaf44xIVFWekMfatxf37SQWs9mtjSVZ4Z55q6DKhi7VtIStecgbLUnx69BAWwDzhALhu+QBrhoXMdOfk7HtfAVgpE2mjhSJMZ1Xns4Cf6J37KMa5BIYAeHXoskdhd0Zbt+Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716571817; c=relaxed/simple;
	bh=8o+itX2K4X+tuNJsVLYSRal6B5j2GbNfwMKJzwHCszU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gktP2MSomhdPmADEUhMxAYV0f4XunZYESwMFgsDUTmIi22F/7hWnuiF8M2cRRk3j9c4MOZb++/LXWUPvEBl71aVJLp157nKa0TCyC4/oDPdy21dBU7xwdnlJGiuda9Gk6eGRHdmrTkGWSsKOAKWV8ieQsC8FlE+e2g+KME43UeM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=KI0C2HNR; arc=none smtp.client-ip=91.218.175.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="KI0C2HNR"
X-Envelope-To: mathieu.desnoyers@efficios.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1716571813;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=B4Nq0eB//d4i3EFi6pEowHgt0pasM4PkRAR32O+xErA=;
	b=KI0C2HNRPc/3Bd2vfC42vI7mc+saav3UaeVAVul/9/tbke+Nd45V7NHjG48qyNeSO3OQGO
	oAXo3KdJTpKtHqNdIIzuutkXLKlB0GwM7Czsc+0Z0RN+FPny8BEyXJ7ts4cegOLA+jNk4z
	5so3BsHTLQsUhJ/hPTFPjaoBHqF47D8=
X-Envelope-To: bfoster@redhat.com
X-Envelope-To: keescook@chromium.org
X-Envelope-To: linux-kernel@vger.kernel.org
X-Envelope-To: linux-bcachefs@vger.kernel.org
X-Envelope-To: glider@google.com
X-Envelope-To: elver@google.com
X-Envelope-To: dvyukov@google.com
X-Envelope-To: kasan-dev@googlegroups.com
X-Envelope-To: nathan@kernel.org
X-Envelope-To: ndesaulniers@google.com
X-Envelope-To: morbo@google.com
X-Envelope-To: justinstitt@google.com
X-Envelope-To: llvm@lists.linux.dev
Date: Fri, 24 May 2024 13:30:09 -0400
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Brian Foster <bfoster@redhat.com>, Kees Cook <keescook@chromium.org>, 
	linux-kernel <linux-kernel@vger.kernel.org>, linux-bcachefs@vger.kernel.org, 
	Alexander Potapenko <glider@google.com>, Marco Elver <elver@google.com>, 
	Dmitry Vyukov <dvyukov@google.com>, kasan-dev@googlegroups.com, 
	Nathan Chancellor <nathan@kernel.org>, Nick Desaulniers <ndesaulniers@google.com>, 
	Bill Wendling <morbo@google.com>, Justin Stitt <justinstitt@google.com>, llvm@lists.linux.dev
Subject: Re: Use of zero-length arrays in bcachefs structures inner fields
Message-ID: <jqj6do7lodrrvpjmk6vlhasdigs23jkyvznniudhebcizstsn7@6cetkluh4ehl>
References: <986294ee-8bb1-4bf4-9f23-2bc25dbad561@efficios.com>
 <vu7w6if47tv3kwnbbbsdchu3wpsbkqlvlkvewtvjx5hkq57fya@rgl6bp33eizt>
 <944d79b5-177d-43ea-a130-25bd62fc787f@efficios.com>
 <7236a148-c513-4053-9778-0bce6657e358@efficios.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <7236a148-c513-4053-9778-0bce6657e358@efficios.com>
X-Migadu-Flow: FLOW_OUT

On Fri, May 24, 2024 at 12:04:11PM -0400, Mathieu Desnoyers wrote:
> On 2024-05-24 11:35, Mathieu Desnoyers wrote:
> > [ Adding clang/llvm and KMSAN maintainers/reviewers in CC. ]
> > 
> > On 2024-05-24 11:28, Kent Overstreet wrote:
> > > On Thu, May 23, 2024 at 01:53:42PM -0400, Mathieu Desnoyers wrote:
> > > > Hi Kent,
> > > > 
> > > > Looking around in the bcachefs code for possible causes of this KMSAN
> > > > bug report:
> > > > 
> > > > https://lore.kernel.org/lkml/000000000000fd5e7006191f78dc@google.com/
> > > > 
> > > > I notice the following pattern in the bcachefs structures: zero-length
> > > > arrays members are inserted in structures (not always at the end),
> > > > seemingly to achieve a result similar to what could be done with a
> > > > union:
> > > > 
> > > > fs/bcachefs/bcachefs_format.h:
> > > > 
> > > > struct bkey_packed {
> > > >          __u64           _data[0];
> > > > 
> > > >          /* Size of combined key and value, in u64s */
> > > >          __u8            u64s;
> > > > [...]
> > > > };
> > > > 
> > > > likewise:
> > > > 
> > > > struct bkey_i {
> > > >          __u64                   _data[0];
> > > > 
> > > >          struct bkey     k;
> > > >          struct bch_val  v;
> > > > };
> > > > 
> > > > (and there are many more examples of this pattern in bcachefs)
> > > > 
> > > > AFAIK, the C11 standard states that array declarator constant expression
> > > > 
> > > > Effectively, we can verify that this code triggers an undefined behavior
> > > > with:
> > > > 
> > > > #include <stdio.h>
> > > > 
> > > > struct z {
> > > >          int x[0];
> > > >          int y;
> > > >          int z;
> > > > } __attribute__((packed));
> > > > 
> > > > int main(void)
> > > > {
> > > >          struct z a;
> > > > 
> > > >          a.y = 1;
> > > >          printf("%d\n", a.x[0]);
> > > > }
> > > > delimited by [ ] shall have a value greater than zero.
> > > 
> > > Yet another example of the C people going absolutely nutty with
> > > everything being undefined. Look, this isn't ok, we need to get work
> > > done, and I've already wasted entirely too much time on ZLA vs. flex
> > > array member nonsense.
> > > 
> > > There's a bunch of legit uses for zero length arrays, and your example,
> > > where we're not even _assigning_ to x, is just batshit. Someone needs to
> > > get his head examined.
> 
> Notice how a.y is first set to 1, then a.x[0] is loaded, expecting to
> alias with a.y.
> 
> This is the same aliasing pattern found in bcachefs, for instance here:
> 
> bcachefs_format.h:
> 
> struct jset {
> [...]
>         __u8                    encrypted_start[0];
> 
>         __le16                  _read_clock; /* no longer used */
>         __le16                  _write_clock;
> 
>         /* Sequence number of oldest dirty journal entry */
>         __le64                  last_seq;
> 
> 
>         struct jset_entry       start[0];
>         __u64                   _data[];
> } __packed __aligned(8);
> 
> where struct jset last_seq field is set by jset_validate():
> 
> 		jset->last_seq = jset->seq;
> 
> and where journal_read_bucket() uses the encrypted_start member as input:
> 
>                 ret = bch2_encrypt(c, JSET_CSUM_TYPE(j), journal_nonce(j),
>                              j->encrypted_start,
>                              vstruct_end(j) - (void *) j->encrypted_start);

Except we're just using it as a marker for an offset into the struct,
the same "aliasing" issue would apply if we were just using offsetof()
to calculate the offsets directly.

