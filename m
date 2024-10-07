Received: from fout-a7-smtp.messagingengine.com (fout-a7-smtp.messagingengine.com [103.168.172.150])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A5EC132111;
	Mon,  7 Oct 2024 03:56:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.150
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728273409; cv=none; b=Qr8Kbch4CoLOxrN6uDm/XQaOJxnSVpyvYfFXf/0upfrYopwlTViIhSH8XWjLbNKqcqNFBCKzei2e7c9/8HzV25dlxrYKJTjNRYIteVF6UYQMqG767QmIy5uh4CgWHh+bbExrGsmcJosHStCUXK4uj3xK+I93KT1bufsuZ8KfD8I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728273409; c=relaxed/simple;
	bh=lH9s8bbZJrZiFlvMC/RHqAn9Zs+WG2MJghOAZrDhHI4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CC2728Ep+8b36Zby+jCZKOxg5Wh17h/dF6glPMseerc9S13olQZBLZzIhYHf8s9XmA9c41IUn2A20bjoM1CP1ZJo4nz3cU4FkqFpZ9xXJ6F6NZ/Vb7pAclL6YZAFSPtRy+hi6lw+++ozvNqIn+A4z69tQg5O2Nr+mWFjfov4YQU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=jfarr.cc; spf=pass smtp.mailfrom=jfarr.cc; dkim=pass (2048-bit key) header.d=jfarr.cc header.i=@jfarr.cc header.b=LyTVPI1Q; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=iZLpugB9; arc=none smtp.client-ip=103.168.172.150
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=jfarr.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=jfarr.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=jfarr.cc header.i=@jfarr.cc header.b="LyTVPI1Q";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="iZLpugB9"
Received: from phl-compute-11.internal (phl-compute-11.phl.internal [10.202.2.51])
	by mailfout.phl.internal (Postfix) with ESMTP id 7BB3D1380434;
	Sun,  6 Oct 2024 23:56:46 -0400 (EDT)
Received: from phl-mailfrontend-02 ([10.202.2.163])
  by phl-compute-11.internal (MEProxy); Sun, 06 Oct 2024 23:56:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=jfarr.cc; h=cc
	:cc:content-type:content-type:date:date:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:subject
	:subject:to:to; s=fm1; t=1728273406; x=1728359806; bh=Itz+DJzSEQ
	bbfn6sj5P7OpOSJDpoWmBmfAXlngRypP0=; b=LyTVPI1Qul7+G9SqkAC/QlhbMj
	Ta4jhM5gQ5lk/ax6ysdcrz5P7HmeNHinU3RtYIgQPwa4zli2VHWWdxSxiudhproy
	5tMMLysmmGEh7QOXWGU+I2bOQ1aBQy29aZOUbvTv2qyA4g4fBzqPhbxHewWcU5vO
	VLVeEWRsTNMoF8ufJfMNtFxOOimtq+u0EfLqFt+4+EroNyeQTUzLf913/0vZ6N+C
	RywltlMscWVODfLNUsXCY54pixnpZzvLyVEHYcpu6+nWgWb5y8KBaEuUctw9osDM
	RBWbbJXMoNNDPQhVWRnHqMvFH81u5ONn2dnQn7rYcMNRRvuBpCbraiervBaw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
	fm2; t=1728273406; x=1728359806; bh=Itz+DJzSEQbbfn6sj5P7OpOSJDpo
	WmBmfAXlngRypP0=; b=iZLpugB9IcFwxTgAp0pu5Y+FfWjWbWztyhEXx6f/Z/oS
	Ys0tlhWNHkrHjOQ3/QS3EEaHnc/90755WVOZVJYTwyNpSQIqkXZRv+lJlT5Mh+Vd
	mFAVQedMCGgBO7LXrZYe1n/SE8cUBRmxDcOa0Kw3XWw2QuWtD+EBNINA35cXe5dd
	wQQqCq8jWPdhhu4QnyISYG8HcrscfjCYcL7YNr3ChtNrMmHyZ0HcsRik8KtDu3pj
	vTPsQjU4lH0pSU0LX3ZbiAXAwWVi/DUS3oQqxr2rfXugLhieGtO7fZfA/zl4/7s0
	lLEFhW2biNUxOLQJVy5fwm0mK8h5PkruDyuN/6Jr4A==
X-ME-Sender: <xms:_lsDZ8g6hzHAskVUxn7XoTk8r-_Xtudx4-9F7jcZBG0Cens5KZHMlg>
    <xme:_lsDZ1DTuX21nHaBINlmOlhYHi1EK-_z7OqDsxYRaChkkxQ6BVlM7-7GcwvgaQN1-
    hm3BXeAewXGLWFBd9c>
X-ME-Received: <xmr:_lsDZ0ExGaE4TKbM1QdoYBv3piuvtCAFH14XvRuCrOsXq4di-4pX05gV6rQkNyJI6NQ_69pVdccWJXB1cXwKYzyzUqCT>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeftddrvddvkedgjeekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdggtfgfnhhsuhgsshgtrhhisggvpdfu
    rfetoffkrfgpnffqhgenuceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnh
    htshculddquddttddmnegfrhhlucfvnfffucdludehmdenucfjughrpeffhffvvefukfhf
    gggtuggjsehttdertddttddvnecuhfhrohhmpeflrghnucfjvghnughrihhkucfhrghrrh
    cuoehkvghrnhgvlhesjhhfrghrrhdrtggtqeenucggtffrrghtthgvrhhnpeeiheevudei
    gffftdeghedvtedugeffjeduheeugeehgeeiveetkeevhfeivdefgeenucffohhmrghinh
    epghhouggsohhlthdrohhrghdpohhpvghnqdhsthgurdhorhhgnecuvehluhhsthgvrhfu
    ihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepkhgvrhhnvghlsehjfhgrrhhrrd
    gttgdpnhgspghrtghpthhtohepledpmhhouggvpehsmhhtphhouhhtpdhrtghpthhtohep
    khgvvghssehkvghrnhgvlhdrohhrghdprhgtphhtthhopehthhhorhhsthgvnhdrsghluh
    hmsehtohgslhhugidrtghomhdprhgtphhtthhopehkvghnthdrohhvvghrshhtrhgvvght
    sehlihhnuhigrdguvghvpdhrtghpthhtoheprhgvghhrvghsshhiohhnsheslhhishhtsh
    drlhhinhhugidruggvvhdprhgtphhtthhopehlihhnuhigqdgstggrtghhvghfshesvhhg
    vghrrdhkvghrnhgvlhdrohhrghdprhgtphhtthhopehlihhnuhigqdhhrghruggvnhhinh
    hgsehvghgvrhdrkhgvrhhnvghlrdhorhhgpdhrtghpthhtoheplhhinhhugidqkhgvrhhn
    vghlsehvghgvrhdrkhgvrhhnvghlrdhorhhgpdhrtghpthhtoheprghruggssehkvghrnh
    gvlhdrohhrghdprhgtphhtthhopehmohhrsghosehgohhoghhlvgdrtghomh
X-ME-Proxy: <xmx:_lsDZ9TKyUQgr7mEzitlSzKIOgSgEjo0bcmGxSisnzbLJn6dASaEnQ>
    <xmx:_lsDZ5yY2aW8mnBxCCgqDx7wwyz2WEtG-dlzmWCLtypgjBCj77wQjg>
    <xmx:_lsDZ76-eJWpRSkBF4oGFjRoTY5oE0Wbu_MUCInS8JiOJGWPrQaW2Q>
    <xmx:_lsDZ2x8jS1nh68qUl1lJ83ONDv0n1zE-49Wz3taJDjgKs-APrM3Ug>
    <xmx:_lsDZ5dI949piUvF6q58VSffcPRfaRyEyIEA0Hkkq6wduAXv4dA9DXQH>
Feedback-ID: i01d149f8:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 6 Oct 2024 23:56:44 -0400 (EDT)
Date: Mon, 7 Oct 2024 05:56:43 +0200
From: Jan Hendrik Farr <kernel@jfarr.cc>
To: Kees Cook <kees@kernel.org>
Cc: Thorsten Blum <thorsten.blum@toblux.com>, kent.overstreet@linux.dev,
	regressions@lists.linux.dev, linux-bcachefs@vger.kernel.org,
	linux-hardening@vger.kernel.org, linux-kernel@vger.kernel.org,
	ardb@kernel.org, morbo@google.com
Subject: Re: [REGRESSION][BISECTED] erroneous buffer overflow detected in
 bch2_xattr_validate
Message-ID: <ZwNb-_UPL9BPSg9N@archlinux>
References: <A499F119-5F0C-43FC-9058-7AB92057F9B3@toblux.com>
 <Zvg-mDsvvOueGpzs@archlinux>
 <202409281331.1F04259@keescook>
 <21D2A2BB-F442-480D-8B66-229E8C4A63D3@toblux.com>
 <Zv6BEO-1Y0oJ3krr@archlinux>
 <E8E64A72-3C1C-40D2-9F07-415F6B8F476E@toblux.com>
 <Zv61dCaxScXuOjZg@archlinux>
 <202410031424.45E5D19@keescook>
 <Zv8RIs-htdc-PtXB@archlinux>
 <202410040958.C19D3B9E48@keescook>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202410040958.C19D3B9E48@keescook>

> I want to separate several easily confused issues. Instead of just
> saying __bdos, let's clearly refer to what calculation within bdos is
> being used. There are 3 choices currently:
> - alloc_size attribute
> - counted_by attribute
> - fallback to __bos (which is similar to sizeof(), except that FAMs are 0 sized)
> 
> Additionally there are (for all intents and purposes) 2 size
> determinations to be made by __bos and __bdos, via argument 2:
> - containing object size (type 0) ("maximum size")
> - specific object size (type 1) ("minimum size")

"maximum" vs "minimum" size would by type 0 vs type 2, but I think you
do mean type 0 and type 1 as those are the types currently used by
__struct_size and __member_size. Those are both "maximum" sizes.

> 
> For example, consider:
> 
> struct posix_acl *acl = malloc(1024);
> acl->a_count = 1;
> 
> what should these return:
> 
> 	__bos(acl, 0)
> 	__bos(acl, 1)
> 	__bdos(acl, 0)
> 	__bdos(acl, 1)
> 	__bos(acl->a_entries, 0)
> 	__bos(acl->a_entries, 1)
> 	__bdos(acl->a_entries, 0)
> 	__bdos(acl->a_entries, 1)
> 

I gathered some data from clang and gcc on all for all these cases and
additionally varied whether the allocation size is a compile time known
constant, runtime known, or not known. I also varied whether
__counted_by was used.

Source code: [1]


Abbreviations:

FAM      = flexible array member
-1       = SIZE_MAX
p->a_ent = p->a_entries
comp.    = allocation size is compile time known
run.     = allocation size is compile time known
none     = allocation size is unknown
count    = __counted_by attribute in use
correct  = What I think the correct answers should be. In some places I
have two answers. In that case the second number is what the kernel
currently expects.


And here's the data:

function        |comp.|run.|none|count| gcc  |clang |correct
----------------|-----|----|----|-----|------|------|-----
bos(p, 0)       |  x  |    |    |     | 1024 | 1024 | 1024
bos(p, 0)       |     | x  |    |     |  -1  |  -1  | -1
bos(p, 0)       |     |    | x  |     |  -1  |  -1  | -1
bos(p, 0)       |  x  |    |    |  x  | 1024 | 1024 | 1024
bos(p, 0)       |     | x  |    |  x  |  -1  |  -1  | -1
bos(p, 0)       |     |    | x  |  x  |  -1  |  -1  | -1
----------------|-----|----|----|-----|------|------|-----
bos(p, 1)       |  x  |    |    |     | 1024 | 1024 | 1024
bos(p, 1)       |     | x  |    |     |  -1  |  -1  | -1
bos(p, 1)       |     |    | x  |     |  -1  |  -1  | -1
bos(p, 1)       |  x  |    |    |  x  | 1024 | 1024 | 1024
bos(p, 1)       |     | x  |    |  x  |  -1  |  -1  | -1
bos(p, 1)       |     |    | x  |  x  |  -1  |  -1  | -1
----------------|-----|----|----|-----|------|------|-----
bdos(p, 0)      |  x  |    |    |     | 1024 | 1024 | 1024
bdos(p, 0)      |     | x  |    |     | 1024 | 1024 | 1024
bdos(p, 0)      |     |    | x  |     |  -1  |  -1  | -1
bdos(p, 0)      |  x  |    |    |  x  | 1024 |  36  | 43 / 40
bdos(p, 0)      |     | x  |    |  x  | 1024 |  36  | 43 / 40
bdos(p, 0)      |     |    | x  |  x  |  -1  |  36  | 43 / 40
----------------|-----|----|----|-----|------|------|-----
bdos(p, 1)      |  x  |    |    |     | 1024 | 1024 | 1024
bdos(p, 1)      |     | x  |    |     | 1024 | 1024 | 1024
bdos(p, 1)      |     |    | x  |     |  -1  |  -1  | -1
bdos(p, 1)      |  x  |    |    |  x  | 1024 |  36  | 43 / 40
bdos(p, 1)      |     | x  |    |  x  | 1024 |  36  | 43 / 40
bdos(p, 1)      |     |    | x  |  x  |  -1  |  36  | 43 / 40
----------------|-----|----|----|-----|------|------|-----
bos(p->a_ent, 0)|  x  |    |    |     |  996 | 996  | 996
bos(p->a_ent, 0)|     | x  |    |     |  -1  |  -1  | -1
bos(p->a_ent, 0)|     |    | x  |     |  -1  |  -1  | -1
bos(p->a_ent, 0)|  x  |    |    |  x  |  996 | 996  | 996
bos(p->a_ent, 0)|     | x  |    |  x  |  -1  |  -1  | -1
bos(p->a_ent, 0)|     |    | x  |  x  |  -1  |  -1  | -1
----------------|-----|----|----|-----|------|------|-----
bos(p->a_ent, 1)|  x  |    |    |     |  996 | 996  | 992
bos(p->a_ent, 1)|     | x  |    |     |  -1  |  -1  | -1
bos(p->a_ent, 1)|     |    | x  |     |  -1  |  -1  | -1
bos(p->a_ent, 1)|  x  |    |    |  x  |  996 | 996  | 992
bos(p->a_ent, 1)|     | x  |    |  x  |  -1  |  -1  | -1
bos(p->a_ent, 1)|     |    | x  |  x  |  -1  |  -1  | -1
----------------|-----|----|----|-----|------|------|-----
bdos(p->a_ent,0)|  x  |    |    |     |  996 | 996  | 996
bdos(p->a_ent,0)|     | x  |    |     |  996 | 996  | 996
bdos(p->a_ent,0)|     |    | x  |     |  -1  |  -1  | -1
bdos(p->a_ent,0)|  x  |    |    |  x  |   8  |  8   |  8
bdos(p->a_ent,0)|     | x  |    |  x  |   8  |  8   |  8
bdos(p->a_ent,0)|     |    | x  |  x  |   8  |  8   |  8
----------------|-----|----|----|-----|------|------|-----
bdos(p->a_ent,1)|  x  |    |    |     |  996 | 996  | 992
bdos(p->a_ent,1)|     | x  |    |     |  996 | 996  | 992
bdos(p->a_ent,1)|     |    | x  |     |  -1  |  -1  | -1
bdos(p->a_ent,1)|  x  |    |    |  x  |   8  |  8   |  8
bdos(p->a_ent,1)|     | x  |    |  x  |   8  |  8   |  8
bdos(p->a_ent,1)|     |    | x  |  x  |   8  |  8   |  8
----------------|-----|----|----|-----|------|------|-----

bos only uses the allocation size to give it's answers. It only works if
it is a compile time known constant. bos also does not utilize the
__counted_by attribute.

bdos on the other hand allows the allocation size to be runtime known.
It also makes use of the __counted_by attribute if present, which always
takes precedence over the allocation size when the compiler supports it
for the particular case. So in those cases you can "lie" to the compiler
about the size of an object.

clang supports the __counted_by attribute for both cases (p and
p->a_entries). gcc only supports it for p->a_entries cases.



Issue A (clang)
=======

function        |comp.|run.|none|count| gcc  |clang |correct
----------------|-----|----|----|-----|------|------|-----
bdos(p, 0)      |  x  |    |    |  x  | 1024 |  36  | 43 / 40
bdos(p, 0)      |     | x  |    |  x  | 1024 |  36  | 43 / 40
bdos(p, 0)      |     |    | x  |  x  |  -1  |  36  | 43 / 40
bdos(p, 1)      |  x  |    |    |  x  | 1024 |  36  | 43 / 40
bdos(p, 1)      |     | x  |    |  x  | 1024 |  36  | 43 / 40
bdos(p, 1)      |     |    | x  |  x  |  -1  |  36  | 43 / 40

These cases also represent the "bdos off by 4" issue in clang. clang
will compute these results using:

max(sizeof(struct posix_acl), offsetof(struct posix_acl, a_entries) +
count * sizeof(struct posix_acl_entries)) = 36

The kernel on the other hand expects this behavior:

sizeof(struct posix_acl) + count * sizeof(struct posix_acl_entries) = 40


I think the correct calculation would actually be this:

offsetof(struct posix_acl, a_entries)
+ (acl->a_count + 1) * sizeof(struct posix_acl_entry) - 1 = 43

The C11 standard says that when the . or -> operator is used on a struct
with an FAM it behaves like the FAM was replaced with the largest array
(with the same element type) that would not make the object any larger
(see page 113 and 114 of [2]).
So there are actually multiple sizes of the object that are consistent
with a count of 1.

malloc-max = maximum size of the object
malloc-min = minimum size of the object
FAME = flexible array member element
(FAME) = hypothetical 2nd FAME

<-----------------malloc-max-------------->
<-----------------malloc-min------->
<------sizeof(posix_acl)------->
                            <-FAME-><(FAME)>

The clang documentation of type 0 (vs type 2) bdos says this:

If ``type & 2 == 0``, the least ``n`` is returned such that accesses to 
   ``(const char*)ptr + n`` and beyond are known to be out of bounds.

We only _know_ that that access to the last byte of a 2nd hypothetical FAME
would be out of bounds. All the bytes before that are padding that is
allowed by the standard.


However, also this calculation doesn't get the kernel out
of trouble here. While this would fix the issue for this particular
struct it does not solve it for all structs:

What if the elements of the FAM were chars instead of
struct posix_acl_entries here? In that case the kernel is back to
overestimating the size of the struct / underreporting the count to the
compiler. So while I think this answer is more correct it doesn't
actually solve the issue.

Example:
Let's say the kernel allocates one of these posix_acl_char structs for a
single char in the array:

malloc(sizeof(posix_acl_char) + 1 * sizeof(char)) = 33

The C standard actually says that this object will behave like this when
the FAM is accessed:

struct posix_acl {
    refcount_t a_refcount;
    struct rcu_head a_rcu;
    unsigned int a_count;
    char a_entries[5];
};

a_count should be set to 5, not 1!


So we would really need an option to tell the compiler to use the same
size calculation as the kernel expects here, or maybe be able to specify
an offset in the __counted_by attribute. Alternatively clang could use
an option to disable the use of __counted_by for cases where the whole
struct is passed. This would make it behave like gcc.



Issue B (clang + gcc)
=======

A less serious issue happens with these cases:

function        |comp.|run.|none|count| gcc  |clang |correct
----------------|-----|----|----|-----|------|------|-----
bos(p->a_ent, 1)|  x  |    |    |     |  996 | 996  | 992
bos(p->a_ent, 1)|  x  |    |    |  x  |  996 | 996  | 992
bdos(p->a_ent,1)|  x  |    |    |     |  996 | 996  | 992
bdos(p->a_ent,1)|     | x  |    |     |  996 | 996  | 992

In this case the size returned by bos/bdos is too large, so this won't
lead to false positives. Both clang and gcc simply compute the difference
between the pointer from the start of the FAM to the end of the whole
struct. I believe this is wrong. According to the C standard the object
should behave like the FAM was replaced with the largest array that does
not make the object any larger. The size of that array is 124 elements.
So the posix_acl becomes:

struct posix_acl {
    refcount_t a_refcount;
    struct rcu_head a_rcu;
    unsigned int a_count;
    struct posix_acl_entry a_entries[124];
};

Since this is a type 1 bos/bdos it should return the size of just the
array, which is 124 * 8 = 992, and not 124.5 * 8 = 996.

[1] https://godbolt.org/z/a5eM3z8PY
[2] https://www.open-std.org/jtc1/sc22/wg14/www/docs/n1548.pdf

Best Regards
Jan

