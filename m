Received: from out-172.mta1.migadu.com (out-172.mta1.migadu.com [95.215.58.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09BE2171082
	for <linux-bcachefs@vger.kernel.org>; Tue, 28 May 2024 15:02:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716908535; cv=none; b=NKGKEm5XPRrD/HPpJOnBOpWLDRCiocFebMOGSrW3hYYWA1ibyt7aeoOwKjQrOezcRMkLUOmpGBt3fuCGFpmdcX/fcCFykNWQvT2W24FeFBTF+nNpGblpnntQdiWKDqRt4HENp9I3zilyjHMmB740DssK898LYYa62wSIcEd3VC8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716908535; c=relaxed/simple;
	bh=5ZHpZGACX2Frn3dDPf3fXyWybxr2L7JiyfRf2W2/hW0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=P+YuRlbbbLSot7LhsWAeFBXdRfgiBFg3PEgjoBz7RbE0ulB1yIAzIylQffK4AnFUDi3mn9C5CAYVa4A9JyXzbNdsLFu3Iasg464H5N4cOWrdVLuNz81A/LUUkidsfUglTCuZLrw0p2f3y2GT6WL0Ok+h81xSVrjsCNOiWK+nkNQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=opoXfCNq; arc=none smtp.client-ip=95.215.58.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="opoXfCNq"
X-Envelope-To: glider@google.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1716908532;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=dKnPZ9OJHpypgolMUhUxX3o8dY3J/6CO95tM7cGqfv8=;
	b=opoXfCNqL0eaKrPq9sbb09xqDBlnVf51DlM6AdAAiU/XeLeu4KiMfvs8PGhdiophKkgpNx
	4GMqFrplyQMupkP+yleNmZRmTkTXWHz5B0AWJMb6bufOkv6bZSG3IUOYbdoG9kCJZwp3/z
	J71p/VMOEAsFEaZQ3BGiLIx0kDif3Xc=
X-Envelope-To: mathieu.desnoyers@efficios.com
X-Envelope-To: bfoster@redhat.com
X-Envelope-To: keescook@chromium.org
X-Envelope-To: linux-kernel@vger.kernel.org
X-Envelope-To: linux-bcachefs@vger.kernel.org
X-Envelope-To: elver@google.com
X-Envelope-To: dvyukov@google.com
X-Envelope-To: kasan-dev@googlegroups.com
X-Envelope-To: nathan@kernel.org
X-Envelope-To: ndesaulniers@google.com
X-Envelope-To: morbo@google.com
X-Envelope-To: justinstitt@google.com
X-Envelope-To: llvm@lists.linux.dev
Date: Tue, 28 May 2024 11:02:05 -0400
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Alexander Potapenko <glider@google.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
	Brian Foster <bfoster@redhat.com>, Kees Cook <keescook@chromium.org>, 
	linux-kernel <linux-kernel@vger.kernel.org>, linux-bcachefs@vger.kernel.org, Marco Elver <elver@google.com>, 
	Dmitry Vyukov <dvyukov@google.com>, kasan-dev@googlegroups.com, 
	Nathan Chancellor <nathan@kernel.org>, Nick Desaulniers <ndesaulniers@google.com>, 
	Bill Wendling <morbo@google.com>, Justin Stitt <justinstitt@google.com>, llvm@lists.linux.dev
Subject: Re: Use of zero-length arrays in bcachefs structures inner fields
Message-ID: <63zx2cnrf5u2slmabde2wptxvq6a3opvrj2zrkcolw3gdkjdpf@bttdonbctura>
References: <986294ee-8bb1-4bf4-9f23-2bc25dbad561@efficios.com>
 <vu7w6if47tv3kwnbbbsdchu3wpsbkqlvlkvewtvjx5hkq57fya@rgl6bp33eizt>
 <944d79b5-177d-43ea-a130-25bd62fc787f@efficios.com>
 <7236a148-c513-4053-9778-0bce6657e358@efficios.com>
 <jqj6do7lodrrvpjmk6vlhasdigs23jkyvznniudhebcizstsn7@6cetkluh4ehl>
 <CAG_fn=Vp+WoxWw_aA9vr9yf_4qRvu1zqfLDWafR8J41Zd9tX5g@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAG_fn=Vp+WoxWw_aA9vr9yf_4qRvu1zqfLDWafR8J41Zd9tX5g@mail.gmail.com>
X-Migadu-Flow: FLOW_OUT

On Tue, May 28, 2024 at 01:36:11PM +0200, Alexander Potapenko wrote:
> On Fri, May 24, 2024 at 7:30 PM Kent Overstreet
> <kent.overstreet@linux.dev> wrote:
> >
> > On Fri, May 24, 2024 at 12:04:11PM -0400, Mathieu Desnoyers wrote:
> > > On 2024-05-24 11:35, Mathieu Desnoyers wrote:
> > > > [ Adding clang/llvm and KMSAN maintainers/reviewers in CC. ]
> > > >
> > > > On 2024-05-24 11:28, Kent Overstreet wrote:
> > > > > On Thu, May 23, 2024 at 01:53:42PM -0400, Mathieu Desnoyers wrote:
> > > > > > Hi Kent,
> > > > > >
> > > > > > Looking around in the bcachefs code for possible causes of this KMSAN
> > > > > > bug report:
> > > > > >
> > > > > > https://lore.kernel.org/lkml/000000000000fd5e7006191f78dc@google.com/
> > > > > >
> > > > > > I notice the following pattern in the bcachefs structures: zero-length
> > > > > > arrays members are inserted in structures (not always at the end),
> > > > > > seemingly to achieve a result similar to what could be done with a
> > > > > > union:
> > > > > >
> > > > > > fs/bcachefs/bcachefs_format.h:
> > > > > >
> > > > > > struct bkey_packed {
> > > > > >          __u64           _data[0];
> > > > > >
> > > > > >          /* Size of combined key and value, in u64s */
> > > > > >          __u8            u64s;
> > > > > > [...]
> > > > > > };
> > > > > >
> > > > > > likewise:
> > > > > >
> > > > > > struct bkey_i {
> > > > > >          __u64                   _data[0];
> > > > > >
> > > > > >          struct bkey     k;
> > > > > >          struct bch_val  v;
> > > > > > };
> 
> I took a glance at the LLVM IR for fs/bcachefs/bset.c, and it defines
> struct bkey_packed and bkey_i as:
> 
>     %struct.bkey_packed = type { [0 x i64], i8, i8, i8, [0 x i8], [37 x i8] }
>     %struct.bkey_i = type { [0 x i64], %struct.bkey, %struct.bch_val }
> 
> , which more or less looks as expected, so I don't think it could be
> causing problems with KMSAN right now.
> Moreover, there are cases in e.g. include/linux/skbuff.h where
> zero-length arrays are used for the same purpose, and KMSAN handles
> them just fine.
> 
> Yet I want to point out that even GCC discourages the use of
> zero-length arrays in the middle of a struct:
> https://gcc.gnu.org/onlinedocs/gcc/Zero-Length.html, so Clang is not
> unique here.
> 
> Regarding the original KMSAN bug, as noted in
> https://lore.kernel.org/all/0000000000009f9447061833d477@google.com/T/,
> we might be missing the event of copying data from the disk to
> bcachefs structs.
> I'd appreciate help from someone knowledgeable about how disk I/O is
> implemented in the kernel.

If that was missing I'd expect everything to be breaking. What's the
helper that marks memory as initialized?
