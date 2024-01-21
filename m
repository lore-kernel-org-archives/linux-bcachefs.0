Received: from mail-io1-f66.google.com (mail-io1-f66.google.com [209.85.166.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54495376E2;
	Sun, 21 Jan 2024 16:11:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.66
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705853491; cv=none; b=ijTAsKZJvs09c80RVVZG+fMsEh/0XypeHWnwUMsXFiYInoye+YQdWFsRsGatKs2Wjfey71/SFYXSzrNJ9eLP5NEFyZN4bIiFbN/J3qwIYzMZ3O2ExhcsCbft/Rj59q8HxZMiFtYcElbUUDwKYKzra3/HXmmnfswu/oeQ/37zYDM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705853491; c=relaxed/simple;
	bh=KHfILTQu09kI25WvL4T/Zev7kLpIOmmLihCAJhUNB68=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qYbvkJ/gSo7ORg9C5xRRsRh43EkNjd6PYqr92WBhJGfeekT75xqbyk89eNl21AO8PTLbXV4hk0+LfeQLqf6L2MCykEMyP5/5bgWbmM16tqABgV8F3PBzt/s8uB3M4rrnKtKechBOUHh11hAIMkem143utRkIzW/cuNd98u6+5Hs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FrPFO7H1; arc=none smtp.client-ip=209.85.166.66
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FrPFO7H1"
Received: by mail-io1-f66.google.com with SMTP id ca18e2360f4ac-7bc32b0fdadso113902039f.2;
        Sun, 21 Jan 2024 08:11:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1705853489; x=1706458289; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=89YgpIaIWnPKVmzHfu5o8z2/6REYUD8L+4R60J0jIaI=;
        b=FrPFO7H1VB/JnZF2MB+EUQ+bhaXWZwO1fwtKe7B8yb4tjLSY0MIa1YLlZ/QAfNALk6
         mZlJb6aah6jXUeZJ1veKgzx8YoPNfcLJsottIsJspgRc1ckywUD7DsE/I6u/ZT1rVkRq
         CeuC1DDcBRhKVIcbDrps1uCG55dCLvckZhilYMT4XNCorsm00de0IwhHsh+7cID2GaaB
         QZg1xq/4cD+708F0H4e8eQvtRa6I7K5zW7rxOmoeQLjB9HNDijOKi6KC6eE/SWoH9ZIg
         /kRjT6km67qxRX12zNPnw7gEJuzaoFKoZNPxPl8duoIL9fVjkzOcFbnNLMQx1Uln/rYD
         BWVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705853489; x=1706458289;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=89YgpIaIWnPKVmzHfu5o8z2/6REYUD8L+4R60J0jIaI=;
        b=AiOwXK04S5BxvqvgyBQve+lvEh5QVjik3fHIt09v1tXk26X1K/pNhrfm0v4YjvNXVG
         icUulX5k/g4gkDCMjB4D0aGaexLh3B9CrzUJLRFNhm+mJ8da/kZ+cDTKWpyd24wiYSaO
         6XzHEDKE+vjktz7fFWne/5Ln06LdPSIxtmby1E30PwKC3LiyFw5TNzptVH0pmHf6OY8G
         cZ7L0BySDHWG/WMxNOxyWn90TF4oao/FASR9dd6E4z6Ae5UYH2nUS2vYhipXGmjtJRdZ
         ea8rNUeh8EioiMf1LwK340ZikQg1Y++p21ZuOlYwR3INncVU6q6ZYP8/UqgQVrdNTk8d
         Hm5Q==
X-Gm-Message-State: AOJu0Ywi6qOyZAELttKnVOrXTfiOR+chg4wv5vENmIBYmLMMbRIw+m53
	AeuM2HgESGd7tCTfPpO6psePHP7Tz1fs9q30Qu9K6Izkia3WgyBN
X-Google-Smtp-Source: AGHT+IGlIX3qXe8JsjaZQU1MpYrgHaWU1Loq7HudyS2CPsNFhEVlfVq4e8uEQ6f7NvSHZnElOg4HGA==
X-Received: by 2002:a6b:c986:0:b0:7bf:824:d57a with SMTP id z128-20020a6bc986000000b007bf0824d57amr2863585iof.24.1705853487762;
        Sun, 21 Jan 2024 08:11:27 -0800 (PST)
Received: from fedora-laptop (c-73-127-246-43.hsd1.nm.comcast.net. [73.127.246.43])
        by smtp.gmail.com with ESMTPSA id z15-20020a6bc90f000000b007bf05f618f3sm6054987iof.55.2024.01.21.08.11.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 21 Jan 2024 08:11:27 -0800 (PST)
Date: Sun, 21 Jan 2024 09:11:24 -0700
From: Thomas Bertschinger <tahbertschinger@gmail.com>
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Trevor Gross <tmgross@umich.edu>, linux-bcachefs@vger.kernel.org,
	bfoster@redhat.com, Miguel Ojeda <ojeda@kernel.org>,
	rust-for-linux@vger.kernel.org,
	Benno Lossin <benno.lossin@proton.me>
Subject: packed, aligned structs in bcachefs (was: Re: [PATCH TOOLS 0/2]
 convert main() from C to Rust)
Message-ID: <20240121161124.GA151023@fedora-laptop>
References: <20240115052451.145611-1-tahbertschinger@gmail.com>
 <pawxsqxbjncrwtxytattvgizwrtmkis6suokgkb6wfm5xvsnhd@njjz4ywheu2a>
 <20240115175509.GA156208@fedora-laptop>
 <iiraqelv6wtwxcdf2yjtjt26ghejngfantjx7d4mztav27qu7y@gmiztxamveq3>
 <20240115191022.GC156208@fedora-laptop>
 <z7ajmttuzbvtxn4onwoxph6mevqt2rje2nga6cpux73geffias@p5kk7pqnswf6>
 <CALNs47t6qjYZeQKC+ahAaG6iNDGGNe8o+Q8tKhpRynYLWL3R8Q@mail.gmail.com>
 <gpokpnqgj6c2pcmtpiu46jy3kb3tom4xkp3fykg26zx6e3c2qe@zrnl2653qwsk>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <gpokpnqgj6c2pcmtpiu46jy3kb3tom4xkp3fykg26zx6e3c2qe@zrnl2653qwsk>

On Fri, Jan 19, 2024 at 04:37:51PM -0500, Kent Overstreet wrote:
> On Fri, Jan 19, 2024 at 01:05:17PM -0600, Trevor Gross wrote:
> > On Mon, Jan 15, 2024 at 1:22 PM Kent Overstreet
> > <kent.overstreet@linux.dev> wrote:
> > > The main thing that needs to be sorted out is that we require a patched
> > > version of bindgen (since rustc can't yet handle types that are both
> > > packed and aligned); we need to talk to the rust-for-linux people about
> > > whether they'll be ok with switching the kernel to the patched bindgen
> > > until we can get a proper fix into rustc.
> > 
> > Do you have a link to the patches needed? We are wondering if this is
> > something that could be upstreamed.
> 
> The current workaround is to just drop #[repr(align)] if the type is
> both packed and aligned - but that leads to rustc and gcc disagreeing on
> the memory layout of certain types; it only works as long as we're not
> mutating types where this matters from rust code.

I made a script to compare the size and alignment of bcachefs structs
in C vs. in Rust generated by the patched, lossy bindgen. All sizes
were the same, but the following types had different alignment:

bkey			(8 in C, 4 in Rust)
bch_extent_crc32	(8 in C, 4 in Rust)
bch_extent_ptr		(8 in C, 1 in Rust)

I didn't explicitly compare the offsets of all struct members between
Rust and C as I couldn't come up with a trivial way to automate this.
However, I think that if the C struct is packed, and the Rust and C
structs have the same size, you can conclude that all member offsets
are the same. This is because Rust could not increase the offset of a
member (or else the Rust size would be larger), it could not decrease
the offset of a member (because it's already packed), and it could not
reorder the members (because #[repr(C)] prohibits this in Rust).

Given the above logic, I think it's safe to conclude that if a struct
is packed in C, and the size and alignment are the same between C and
Rust, then they are fully ABI compatible. Does anyone see an error in
my reasoning?


Taking a look at struct bkey, the alignment difference arises from a
semantic difference between gcc's __attribute__((packed, aligned(N)))
and rustc's #[repr(C, packed(N))]. In Rust, 

> By specifying this attribute, the alignment of the struct would be
> the smaller of the specified packing and the default alignment of the
> struct. [1]

We can get the same alignment for struct bkey in Rust by modifying
the code from bindgen to use align(8) instead of packed(8). On my
x86_64 Linux system, this results in a struct with the same size,
alignment, and offsets of all members as the original C struct. This
works because the struct happens to be packed already, so the
#[repr(packed)] attribute is superfluous. I can't say if this works in
any other environment with different architecture, endianness, etc. But
introducing an automated test for comparing the size and alignment of
bindgen-generated structs could help with validating other environments.


In general, given a C structure like

struct A {
	...
} __packed __aligned(N);

I think a Rust structure can be created with the same size, alignment,
and member offsets in the following cases: 

(1) #[repr(packed(N))] will have the same layout if N is <= the
    structure's default alignment and all members with a default
    alignment >= N naturally have an offset that is a multiple of N.
    Also, no member can have an alignment attribute as rustc forbids
    this [2].

(2) #[repr(align(N))] will have the same layout if the structure's size
    without the packed attribute is equal to the sum of the size of all
    its members (i.e., it is "naturally packed"), and the structure's
    default alignment is <= N.

(I haven't formally proven these rules and I welcome counterexamples if
someone can spot an error in my logic.)

An example of a struct that I think the current rustc cannot represent:

struct rust_cannot_represent_this {
	u8 a;
	u32 b;
} __packed __aligned(2);

Luckily, I do not think bcachefs has any structs like this.


TL;DR -- even without a rustc fix to support packed and aligned structs,
I think it is possible in many cases to create Rust structs with the
same memory layout, although it may take some manual effort. Perhaps
bindgen could be enhanced with awareness of rule (2) from above, to
automatically cover more cases than it does now?

Of course, a fix to rustc is the best option. It would avoid the need
for error-prone manual work. Specifying both #[repr(packed, align(N))]
also communicates semantic intent more than specifying just one even
when the result is the same. But we could be waiting a while for that
fix to arrive.

[1] https://rust-lang.github.io/rfcs/1399-repr-pack.html
[2] https://github.com/rust-lang/rust/issues/100743

- Thomas Bertschinger
