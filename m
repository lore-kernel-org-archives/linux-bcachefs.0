Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A1125478E;
	Wed, 16 Oct 2024 21:13:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729113223; cv=none; b=TgpU9ejW2KxBAkKv7RyGmheuVYvh4kSLj05DHIgjkMOubfP5PVjcXcgxe4lfCFGPaC5gcPSn5U9nOAtL8dHZ53aqiAs9Z0nFjtNbI6PFqWF1hA9iHFfDFZmJ1eW+OWct3FIKuRCMiopfjwoGzxiuAaY3Gr6U8p/FCsQGD9hUc7E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729113223; c=relaxed/simple;
	bh=R7fPMSIRHcgweJX2VQvBP6ZOk3+ZtKbAitg4ejoHP68=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nvaoCZUoSK7erf8Khkv/my3wG7F+3FOm4cZb8h1edyl8U3T1q4dAdxvGoWpHc3k0iWVHdwlQOjwVUfFbvHdsi/a0gGtpjKTXZydZlz8+RI3TeI2a4LvSYNEMLKkus7V3e26WHQUtlI0p6jzP+YgRCDvp47+Ed5MnZYJUJKLpBKg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FQ+jgg9J; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FQ+jgg9J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91AB0C4CEC5;
	Wed, 16 Oct 2024 21:13:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729113222;
	bh=R7fPMSIRHcgweJX2VQvBP6ZOk3+ZtKbAitg4ejoHP68=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=FQ+jgg9JLEe4xpfNtmQ6DIvpxVnTm1Yq24HbiV3t5qQtMUNro2eWUrqR3zy+gnCvw
	 ZxdwnQb32m5tZIGbLcAc91fz6bkEEqJSKJeyqw6P2dS7wMFhbgbb2zaXVuLmQr98kT
	 lk/1LuS1pyuqdJ008td0/1OYFRy43d4H0O+NZy7CixcUMe/XpKeHoamVwIn1V1SuK6
	 GZsBZaZXuilqFRl3ZDyf2FSqgH7rSrRSSgGcDBvVj3LzYEkz5iHQZR+TBlO740Q+lb
	 xpeYLy+Vulpb/sOhCsZeD4m6Eu4xk4S4jktNmKITyMvtninzTnwa/3rSZMcOVIcMzl
	 Zc1mMn9TZFi8w==
Date: Wed, 16 Oct 2024 14:13:39 -0700
From: Kees Cook <kees@kernel.org>
To: Jan Hendrik Farr <kernel@jfarr.cc>
Cc: Thorsten Blum <thorsten.blum@toblux.com>, kent.overstreet@linux.dev,
	regressions@lists.linux.dev, linux-bcachefs@vger.kernel.org,
	linux-hardening@vger.kernel.org, linux-kernel@vger.kernel.org,
	ardb@kernel.org, morbo@google.com
Subject: Re: [REGRESSION][BISECTED] erroneous buffer overflow detected in
 bch2_xattr_validate
Message-ID: <202410161343.D871C005@keescook>
References: <202409281331.1F04259@keescook>
 <21D2A2BB-F442-480D-8B66-229E8C4A63D3@toblux.com>
 <Zv6BEO-1Y0oJ3krr@archlinux>
 <E8E64A72-3C1C-40D2-9F07-415F6B8F476E@toblux.com>
 <Zv61dCaxScXuOjZg@archlinux>
 <202410031424.45E5D19@keescook>
 <Zv8RIs-htdc-PtXB@archlinux>
 <202410040958.C19D3B9E48@keescook>
 <ZwNb-_UPL9BPSg9N@archlinux>
 <ZwP5_bY-AmN91_YB@archlinux>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZwP5_bY-AmN91_YB@archlinux>

On Mon, Oct 07, 2024 at 05:10:53PM +0200, Jan Hendrik Farr wrote:
> On 07 05:56:46, Jan Hendrik Farr wrote:
> > > I want to separate several easily confused issues. Instead of just
> > > saying __bdos, let's clearly refer to what calculation within bdos is
> > > being used. There are 3 choices currently:
> > > - alloc_size attribute
> > > - counted_by attribute
> > > - fallback to __bos (which is similar to sizeof(), except that FAMs are 0 sized)
> > > 
> > > Additionally there are (for all intents and purposes) 2 size
> > > determinations to be made by __bos and __bdos, via argument 2:
> > > - containing object size (type 0) ("maximum size")
> > > - specific object size (type 1) ("minimum size")
> > 
> > "maximum" vs "minimum" size would by type 0 vs type 2, but I think you
> > do mean type 0 and type 1 as those are the types currently used by
> > __struct_size and __member_size. Those are both "maximum" sizes.
> > 
> > > 
> > > For example, consider:
> > > 
> > > struct posix_acl *acl = malloc(1024);
> > > acl->a_count = 1;
> > > 
> > > what should these return:
> > > 
> > > 	__bos(acl, 0)
> > > 	__bos(acl, 1)
> > > 	__bdos(acl, 0)
> > > 	__bdos(acl, 1)
> > > 	__bos(acl->a_entries, 0)
> > > 	__bos(acl->a_entries, 1)
> > > 	__bdos(acl->a_entries, 0)
> > > 	__bdos(acl->a_entries, 1)
> > > 
> > 
> > I gathered some data from clang and gcc on all for all these cases and
> > additionally varied whether the allocation size is a compile time known
> > constant, runtime known, or not known. I also varied whether
> > __counted_by was used.
> > 
> > Source code: [1]
> > 
> > 
> > Abbreviations:
> > 
> > FAM      = flexible array member
> > -1       = SIZE_MAX
> > p->a_ent = p->a_entries
> > comp.    = allocation size is compile time known
> > run.     = allocation size is compile time known
> > none     = allocation size is unknown
> > count    = __counted_by attribute in use
> > correct  = What I think the correct answers should be. In some places I
> > have two answers. In that case the second number is what the kernel
> > currently expects.
> > 
> > 
> > And here's the data:
> > 
> > function        |comp.|run.|none|count| gcc  |clang |correct
> > ----------------|-----|----|----|-----|------|------|-----
> > bos(p, 0)       |  x  |    |    |     | 1024 | 1024 | 1024
> > bos(p, 0)       |     | x  |    |     |  -1  |  -1  | -1
> > bos(p, 0)       |     |    | x  |     |  -1  |  -1  | -1
> > bos(p, 0)       |  x  |    |    |  x  | 1024 | 1024 | 1024
> > bos(p, 0)       |     | x  |    |  x  |  -1  |  -1  | -1
> > bos(p, 0)       |     |    | x  |  x  |  -1  |  -1  | -1
> > ----------------|-----|----|----|-----|------|------|-----
> > bos(p, 1)       |  x  |    |    |     | 1024 | 1024 | 1024
> > bos(p, 1)       |     | x  |    |     |  -1  |  -1  | -1
> > bos(p, 1)       |     |    | x  |     |  -1  |  -1  | -1
> > bos(p, 1)       |  x  |    |    |  x  | 1024 | 1024 | 1024
> > bos(p, 1)       |     | x  |    |  x  |  -1  |  -1  | -1
> > bos(p, 1)       |     |    | x  |  x  |  -1  |  -1  | -1
> > ----------------|-----|----|----|-----|------|------|-----
> > bdos(p, 0)      |  x  |    |    |     | 1024 | 1024 | 1024
> > bdos(p, 0)      |     | x  |    |     | 1024 | 1024 | 1024
> > bdos(p, 0)      |     |    | x  |     |  -1  |  -1  | -1
> > bdos(p, 0)      |  x  |    |    |  x  | 1024 |  36  | 43 / 40
> > bdos(p, 0)      |     | x  |    |  x  | 1024 |  36  | 43 / 40
> > bdos(p, 0)      |     |    | x  |  x  |  -1  |  36  | 43 / 40
> > ----------------|-----|----|----|-----|------|------|-----
> > bdos(p, 1)      |  x  |    |    |     | 1024 | 1024 | 1024
> > bdos(p, 1)      |     | x  |    |     | 1024 | 1024 | 1024
> > bdos(p, 1)      |     |    | x  |     |  -1  |  -1  | -1
> > bdos(p, 1)      |  x  |    |    |  x  | 1024 |  36  | 43 / 40
> > bdos(p, 1)      |     | x  |    |  x  | 1024 |  36  | 43 / 40
> > bdos(p, 1)      |     |    | x  |  x  |  -1  |  36  | 43 / 40
> > ----------------|-----|----|----|-----|------|------|-----
> > bos(p->a_ent, 0)|  x  |    |    |     |  996 | 996  | 996
> > bos(p->a_ent, 0)|     | x  |    |     |  -1  |  -1  | -1
> > bos(p->a_ent, 0)|     |    | x  |     |  -1  |  -1  | -1
> > bos(p->a_ent, 0)|  x  |    |    |  x  |  996 | 996  | 996
> > bos(p->a_ent, 0)|     | x  |    |  x  |  -1  |  -1  | -1
> > bos(p->a_ent, 0)|     |    | x  |  x  |  -1  |  -1  | -1
> > ----------------|-----|----|----|-----|------|------|-----
> > bos(p->a_ent, 1)|  x  |    |    |     |  996 | 996  | 992
> > bos(p->a_ent, 1)|     | x  |    |     |  -1  |  -1  | -1
> > bos(p->a_ent, 1)|     |    | x  |     |  -1  |  -1  | -1
> > bos(p->a_ent, 1)|  x  |    |    |  x  |  996 | 996  | 992
> > bos(p->a_ent, 1)|     | x  |    |  x  |  -1  |  -1  | -1
> > bos(p->a_ent, 1)|     |    | x  |  x  |  -1  |  -1  | -1
> > ----------------|-----|----|----|-----|------|------|-----
> > bdos(p->a_ent,0)|  x  |    |    |     |  996 | 996  | 996
> > bdos(p->a_ent,0)|     | x  |    |     |  996 | 996  | 996
> > bdos(p->a_ent,0)|     |    | x  |     |  -1  |  -1  | -1
> > bdos(p->a_ent,0)|  x  |    |    |  x  |   8  |  8   |  8
> > bdos(p->a_ent,0)|     | x  |    |  x  |   8  |  8   |  8
> > bdos(p->a_ent,0)|     |    | x  |  x  |   8  |  8   |  8
> 
> 
> These previous three should probably actually be like this:
> bdos(p->a_ent,0)|  x  |    |    |  x  |   8  |  8   |  15
> bdos(p->a_ent,0)|     | x  |    |  x  |   8  |  8   |  15
> bdos(p->a_ent,0)|     |    | x  |  x  |   8  |  8   |  15
> 
> They should include the allowed padding after the FAM, as this is a type
> 0 bdos. Not really an issue here, as the kernel expects 8 here.
> 
> 
> > ----------------|-----|----|----|-----|------|------|-----
> > bdos(p->a_ent,1)|  x  |    |    |     |  996 | 996  | 992
> > bdos(p->a_ent,1)|     | x  |    |     |  996 | 996  | 992
> > bdos(p->a_ent,1)|     |    | x  |     |  -1  |  -1  | -1
> > bdos(p->a_ent,1)|  x  |    |    |  x  |   8  |  8   |  8
> > bdos(p->a_ent,1)|     | x  |    |  x  |   8  |  8   |  8
> > bdos(p->a_ent,1)|     |    | x  |  x  |   8  |  8   |  8
> > ----------------|-----|----|----|-----|------|------|-----

Thanks for building all these tables -- I want to look at it all again
myself, but I'm pretty well convinced you've found a bunch of things we
need to sort out.

> > bos only uses the allocation size to give it's answers. It only works if
> > it is a compile time known constant. bos also does not utilize the
> > __counted_by attribute.
> > 
> > bdos on the other hand allows the allocation size to be runtime known.
> > It also makes use of the __counted_by attribute if present, which always
> > takes precedence over the allocation size when the compiler supports it
> > for the particular case. So in those cases you can "lie" to the compiler
> > about the size of an object.

I am okay with counted_by winning out over alloc_size when it is present.
However, I would expect this:

void *v = malloc(1024);
struct flex *p = v;
p->counter = 4;

__bdos(p, 1) == struct_size(f, array, 4)	// "p" has both size hints
__bdos(v, 1) == 1024				// "v" only has alloc_size

> > 
> > clang supports the __counted_by attribute for both cases (p and
> > p->a_entries). gcc only supports it for p->a_entries cases.

I think gcc refuses to believe "p" is anything until it has been
dereferenced to a specific type. I would like it if they could fix this,
as if we have a pointer to a type and we're using __bdos to query its
size, we are explicitly treating it as the type it is pointing at (i.e.
examining the counter and evaluating the FAM size).

> > 
> > 
> > 
> > Issue A (clang)
> > =======
> > 
> > function        |comp.|run.|none|count| gcc  |clang |correct
> > ----------------|-----|----|----|-----|------|------|-----
> > bdos(p, 0)      |  x  |    |    |  x  | 1024 |  36  | 43 / 40
> > bdos(p, 0)      |     | x  |    |  x  | 1024 |  36  | 43 / 40
> > bdos(p, 0)      |     |    | x  |  x  |  -1  |  36  | 43 / 40
> > bdos(p, 1)      |  x  |    |    |  x  | 1024 |  36  | 43 / 40
> > bdos(p, 1)      |     | x  |    |  x  | 1024 |  36  | 43 / 40
> > bdos(p, 1)      |     |    | x  |  x  |  -1  |  36  | 43 / 40
> > 
> > These cases also represent the "bdos off by 4" issue in clang. clang
> > will compute these results using:
> > 
> > max(sizeof(struct posix_acl), offsetof(struct posix_acl, a_entries) +
> > count * sizeof(struct posix_acl_entries)) = 36
> > 
> > The kernel on the other hand expects this behavior:
> > 
> > sizeof(struct posix_acl) + count * sizeof(struct posix_acl_entries) = 40
> > 
> > 
> > I think the correct calculation would actually be this:
> > 
> > offsetof(struct posix_acl, a_entries)
> > + (acl->a_count + 1) * sizeof(struct posix_acl_entry) - 1 = 43
> > 
> > The C11 standard says that when the . or -> operator is used on a struct
> > with an FAM it behaves like the FAM was replaced with the largest array
> > (with the same element type) that would not make the object any larger
> > (see page 113 and 114 of [2]).
> > So there are actually multiple sizes of the object that are consistent
> > with a count of 1.
> > 
> > malloc-max = maximum size of the object
> > malloc-min = minimum size of the object
> > FAME = flexible array member element
> > (FAME) = hypothetical 2nd FAME
> > 
> > <-----------------malloc-max-------------->
> > <-----------------malloc-min------->
> > <------sizeof(posix_acl)------->
> >                             <-FAME-><(FAME)>
> > 
> > The clang documentation of type 0 (vs type 2) bdos says this:
> > 
> > If ``type & 2 == 0``, the least ``n`` is returned such that accesses to 
> >    ``(const char*)ptr + n`` and beyond are known to be out of bounds.
> > 
> > We only _know_ that that access to the last byte of a 2nd hypothetical FAME
> > would be out of bounds. All the bytes before that are padding that is
> > allowed by the standard.
> > 
> > 
> > However, also this calculation doesn't get the kernel out
> > of trouble here. While this would fix the issue for this particular
> > struct it does not solve it for all structs:
> > 
> > What if the elements of the FAM were chars instead of
> > struct posix_acl_entries here? In that case the kernel is back to
> > overestimating the size of the struct / underreporting the count to the
> > compiler. So while I think this answer is more correct it doesn't
> > actually solve the issue.
> > 
> > Example:
> > Let's say the kernel allocates one of these posix_acl_char structs for a
> > single char in the array:
> > 
> > malloc(sizeof(posix_acl_char) + 1 * sizeof(char)) = 33
> > 
> > The C standard actually says that this object will behave like this when
> > the FAM is accessed:
> > 
> > struct posix_acl {
> >     refcount_t a_refcount;
> >     struct rcu_head a_rcu;
> >     unsigned int a_count;
> >     char a_entries[5];
> > };
> > 
> > a_count should be set to 5, not 1!

This is making my head spin. In a practical sense, a struct instance
has a fixed size (which I would say is the calculation using max(),
above). Whether the . or -> operators are used shouldn't matter (to
the program's view of the object size).

This "1 becomes 5" should just not be allowed. I can accept object padding
contributing to object size, but we should not redefine the array size
out from under what it actually is. I don't want array accesses into
padding either. :P

I think 36 is correct here, not 40 nor 43.

> > So we would really need an option to tell the compiler to use the same
> > size calculation as the kernel expects here, or maybe be able to specify
> > an offset in the __counted_by attribute. Alternatively clang could use
> > an option to disable the use of __counted_by for cases where the whole
> > struct is passed. This would make it behave like gcc.
> > 
> > 
> > 
> > Issue B (clang + gcc)
> > =======
> > 
> > A less serious issue happens with these cases:
> > 
> > function        |comp.|run.|none|count| gcc  |clang |correct
> > ----------------|-----|----|----|-----|------|------|-----
> > bos(p->a_ent, 1)|  x  |    |    |     |  996 | 996  | 992
> > bos(p->a_ent, 1)|  x  |    |    |  x  |  996 | 996  | 992
> > bdos(p->a_ent,1)|  x  |    |    |     |  996 | 996  | 992
> > bdos(p->a_ent,1)|     | x  |    |     |  996 | 996  | 992
> > 
> > In this case the size returned by bos/bdos is too large, so this won't
> > lead to false positives. Both clang and gcc simply compute the difference
> > between the pointer from the start of the FAM to the end of the whole
> > struct. I believe this is wrong. According to the C standard the object
> > should behave like the FAM was replaced with the largest array that does
> > not make the object any larger. The size of that array is 124 elements.
> > So the posix_acl becomes:
> > 
> > struct posix_acl {
> >     refcount_t a_refcount;
> >     struct rcu_head a_rcu;
> >     unsigned int a_count;
> >     struct posix_acl_entry a_entries[124];
> > };
> > 
> > Since this is a type 1 bos/bdos it should return the size of just the
> > array, which is 124 * 8 = 992, and not 124.5 * 8 = 996.

For type 1, I agree: this needs to be the precise size of the array.

As of now, are GCC and Clang both using:

max(sizeof(*p),
    offsetof(typeof(*p), FAM) + count * sizeof(*p->FAM))

?

Linux can adjust struct_size() to match, and I'll check that nothing
shrunk inappropriately...

-- 
Kees Cook
