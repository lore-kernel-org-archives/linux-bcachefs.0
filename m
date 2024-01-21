Received: from out-175.mta1.migadu.com (out-175.mta1.migadu.com [95.215.58.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D8A8376E2
	for <linux-bcachefs@vger.kernel.org>; Sun, 21 Jan 2024 18:19:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705861172; cv=none; b=SGk0JSfgtI5bzgz3pCiAC8XpY2+aV7GgkR/RpqpwFcpZNoGlqI8Jmq/GzAyMZgIKk5uIRQgZ08c2WR4aC5VvCu0/IM3VIqFhwIwckXe3AbkKhlt4R8Sx8HXCjYJBcVe2EmEOCKK4E0gBtpOU1FnyzDA+eAyO5lxmpiYeGtScK8k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705861172; c=relaxed/simple;
	bh=IJygmFao5VMond2we7L3nojs3WSoRDDJLJcFE9LsJLU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GThkS4ATJP/Re+JSgqJi1CC3rVMHwKgr1sfGREEvf6m35JvUh6ckNsCQvL5AwX80mSF6TQEjPMhksN5rCsTmRIIm00UNQtTsSAEslhuFV6vxKdunwydiDQ0aca9kV6FRpuMeY3qZaxy6ZJux2EyTQp+dHIHY3Y84q/cGBLNkJyA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=LMTj/1aC; arc=none smtp.client-ip=95.215.58.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="LMTj/1aC"
Date: Sun, 21 Jan 2024 13:19:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1705861167;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=WA2wNFy35U18Fv2GZLuoo6cwsJPv0ZU1SCP7MqqRCXs=;
	b=LMTj/1aCFmzT0ZUcQytAPaWDC6Dzx8mfv0b+YopGhGDMpavH3Kg5cuC0ZaJk22WJv4s0d0
	tFu8GIDt+kvH2NQwRyEyABf2exuAuDCFCEAbCr+dcOrmqql0h6K5lOIMY3nggdsSw5b0Hq
	R+6pw97OaeVYobVD/1mxvYW+EqjBCHw=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Thomas Bertschinger <tahbertschinger@gmail.com>
Cc: Trevor Gross <tmgross@umich.edu>, linux-bcachefs@vger.kernel.org, 
	bfoster@redhat.com, Miguel Ojeda <ojeda@kernel.org>, rust-for-linux@vger.kernel.org, 
	Benno Lossin <benno.lossin@proton.me>
Subject: Re: packed, aligned structs in bcachefs (was: Re: [PATCH TOOLS 0/2]
 convert main() from C to Rust)
Message-ID: <cxben4yqhrraso7fiw54hj7wr4minkvxm7ibsh2yl4zew62jpy@xrraic3ceqns>
References: <20240115052451.145611-1-tahbertschinger@gmail.com>
 <pawxsqxbjncrwtxytattvgizwrtmkis6suokgkb6wfm5xvsnhd@njjz4ywheu2a>
 <20240115175509.GA156208@fedora-laptop>
 <iiraqelv6wtwxcdf2yjtjt26ghejngfantjx7d4mztav27qu7y@gmiztxamveq3>
 <20240115191022.GC156208@fedora-laptop>
 <z7ajmttuzbvtxn4onwoxph6mevqt2rje2nga6cpux73geffias@p5kk7pqnswf6>
 <CALNs47t6qjYZeQKC+ahAaG6iNDGGNe8o+Q8tKhpRynYLWL3R8Q@mail.gmail.com>
 <gpokpnqgj6c2pcmtpiu46jy3kb3tom4xkp3fykg26zx6e3c2qe@zrnl2653qwsk>
 <20240121161124.GA151023@fedora-laptop>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20240121161124.GA151023@fedora-laptop>
X-Migadu-Flow: FLOW_OUT

On Sun, Jan 21, 2024 at 09:11:24AM -0700, Thomas Bertschinger wrote:
> On Fri, Jan 19, 2024 at 04:37:51PM -0500, Kent Overstreet wrote:
> > On Fri, Jan 19, 2024 at 01:05:17PM -0600, Trevor Gross wrote:
> > > On Mon, Jan 15, 2024 at 1:22 PM Kent Overstreet
> > > <kent.overstreet@linux.dev> wrote:
> > > > The main thing that needs to be sorted out is that we require a patched
> > > > version of bindgen (since rustc can't yet handle types that are both
> > > > packed and aligned); we need to talk to the rust-for-linux people about
> > > > whether they'll be ok with switching the kernel to the patched bindgen
> > > > until we can get a proper fix into rustc.
> > > 
> > > Do you have a link to the patches needed? We are wondering if this is
> > > something that could be upstreamed.
> > 
> > The current workaround is to just drop #[repr(align)] if the type is
> > both packed and aligned - but that leads to rustc and gcc disagreeing on
> > the memory layout of certain types; it only works as long as we're not
> > mutating types where this matters from rust code.
> 
> I made a script to compare the size and alignment of bcachefs structs
> in C vs. in Rust generated by the patched, lossy bindgen. All sizes
> were the same, but the following types had different alignment:
> 
> bkey			(8 in C, 4 in Rust)
> bch_extent_crc32	(8 in C, 4 in Rust)
> bch_extent_ptr		(8 in C, 1 in Rust)

That right there is really good news. If we can add that script to the
tests in bcachefs-tools, we'll already be in better shape than we were.

I wonder if it would be possible to upstream that check into bindgen.

Also, note: the differing alignment isn't a correctness issue, but it is
definitely a performance issue on arm - the compiler will then have to
generate code to handle misaligned loads and stores.

> I didn't explicitly compare the offsets of all struct members between
> Rust and C as I couldn't come up with a trivial way to automate this.
> However, I think that if the C struct is packed, and the Rust and C
> structs have the same size, you can conclude that all member offsets
> are the same. This is because Rust could not increase the offset of a
> member (or else the Rust size would be larger), it could not decrease
> the offset of a member (because it's already packed), and it could not
> reorder the members (because #[repr(C)] prohibits this in Rust).
> 
> Given the above logic, I think it's safe to conclude that if a struct
> is packed in C, and the size and alignment are the same between C and
> Rust, then they are fully ABI compatible. Does anyone see an error in
> my reasoning?

Agreed. It'd be great to have an easy way of checking member offsets as
well, like we were discussing on IRC, but I don't think it's necessary.

> Taking a look at struct bkey, the alignment difference arises from a
> semantic difference between gcc's __attribute__((packed, aligned(N)))
> and rustc's #[repr(C, packed(N))]. In Rust, 
> 
> > By specifying this attribute, the alignment of the struct would be
> > the smaller of the specified packing and the default alignment of the
> > struct. [1]
> 
> We can get the same alignment for struct bkey in Rust by modifying
> the code from bindgen to use align(8) instead of packed(8). On my
> x86_64 Linux system, this results in a struct with the same size,
> alignment, and offsets of all members as the original C struct. This
> works because the struct happens to be packed already, so the
> #[repr(packed)] attribute is superfluous. I can't say if this works in
> any other environment with different architecture, endianness, etc. But
> introducing an automated test for comparing the size and alignment of
> bindgen-generated structs could help with validating other environments.
> 
> 
> In general, given a C structure like
> 
> struct A {
> 	...
> } __packed __aligned(N);
> 
> I think a Rust structure can be created with the same size, alignment,
> and member offsets in the following cases: 
> 
> (1) #[repr(packed(N))] will have the same layout if N is <= the
>     structure's default alignment and all members with a default
>     alignment >= N naturally have an offset that is a multiple of N.
>     Also, no member can have an alignment attribute as rustc forbids
>     this [2].
> 
> (2) #[repr(align(N))] will have the same layout if the structure's size
>     without the packed attribute is equal to the sum of the size of all
>     its members (i.e., it is "naturally packed"), and the structure's
>     default alignment is <= N.
> 
> (I haven't formally proven these rules and I welcome counterexamples if
> someone can spot an error in my logic.)

That feels right to me; and if we can get your test committed I won't be
too concerned about getting a formal proof :)

> An example of a struct that I think the current rustc cannot represent:
> 
> struct rust_cannot_represent_this {
> 	u8 a;
> 	u32 b;
> } __packed __aligned(2);
> 
> Luckily, I do not think bcachefs has any structs like this.

*nod*

> TL;DR -- even without a rustc fix to support packed and aligned structs,
> I think it is possible in many cases to create Rust structs with the
> same memory layout, although it may take some manual effort. Perhaps
> bindgen could be enhanced with awareness of rule (2) from above, to
> automatically cover more cases than it does now?
> 
> Of course, a fix to rustc is the best option. It would avoid the need
> for error-prone manual work. Specifying both #[repr(packed, align(N))]
> also communicates semantic intent more than specifying just one even
> when the result is the same. But we could be waiting a while for that
> fix to arrive.
> 
> [1] https://rust-lang.github.io/rfcs/1399-repr-pack.html
> [2] https://github.com/rust-lang/rust/issues/100743

Thanks for the writeup, this really helps.

Agreed that if at all possible we should aim for better support from
rustc, and forwarding this to the rustc people might help get this the
necessary attention before we dive in with patching bindgen.

Another thought - the interface between bindgen and rustc feels a bit
fragile here, since the C attributes and Rust reprs don't exactly match.
Can we come up with something better?

I wonder if we could get support in rustc for specifying the offset of
each member directly?

Also - you tracked down the difference between microsoft and gcc
__attribute__((align)), let me try to recap (and tell me if I get it
wrong): with gcc, __align() works like any naturally aligned type, but
Microsoft's version overrides __packed on a containing structure.

I think there's a strong argument to be made that Microsoft is the weird
one here and Rustc should just provide the gcc behaviour when mixing
packed and align...
