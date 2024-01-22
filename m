Received: from mail-il1-f175.google.com (mail-il1-f175.google.com [209.85.166.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 824D8394;
	Mon, 22 Jan 2024 02:47:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705891638; cv=none; b=V5HIzhUeWNB62LUcN2NR/2tskio1qqWh4XvRC80L1n27H+BStquPGgX0jgMPMtkT3/QmcqTjzyKzPSHd5jqPIatcA9DNlriabU8IuE4Ma4JsFkzAzdqoj14kaVv98HamG8xWggjsiVQyK9O/WJp987+s+pXHrBOqk4qoCSXRFGY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705891638; c=relaxed/simple;
	bh=PdSoGdptZWFjNDb4EbIj3ndlndsl8C+Al66iqz8MtQ0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tUenjJ0AOb9rrwbRDgVx04MRwzJw067AKjtVfAqT3uqKgN3J7zDLQNjhJOrhH9gzMvyOGBA+2ns3vljrfzZeBigRWuuPy4y40aGwTVS93obN4THAsCCMY+6clFV6l0hz4ogYwvRc2IpUpPMi/cFkky7aNCOk9t6WqhCpCMH2c6k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=IkdLYp77; arc=none smtp.client-ip=209.85.166.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IkdLYp77"
Received: by mail-il1-f175.google.com with SMTP id e9e14a558f8ab-3619e804f2aso6737825ab.2;
        Sun, 21 Jan 2024 18:47:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1705891636; x=1706496436; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=GX3pSxrY3aBKNpG2FRE7Ndm5aKev69TazfrkDbhfzx8=;
        b=IkdLYp77tDtPb1pooQRzB8ARYAdWePYXJ1nWCIGx7QTEVfUlgNwO/8efu1HXnlGkkG
         i+4Jc12YQC2DTEfi4+1wCx+80zFdYPlx8pIFpBAN/6PlrNJiFNPdFfKhKXXJbrdatp20
         JDBa691jKw3rVa3ddBJ4QffLEI11EvO+fdvKK5FQcO5snQ29tX7FI3ZLhBleQKxFtW6o
         7ed57RHzFObwj6QauKGTZI+VuSJK4qRCPGeGcE6Rtm2BXJE6FVXwXWTYQtkEIwtP9mmP
         VXHb8EMyvKHmc9r62iwfA/ak/uJmVYk3PTBs2kv020JQ+AQlOWOxhcsPzVDT7b8FDUCa
         cHtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705891636; x=1706496436;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GX3pSxrY3aBKNpG2FRE7Ndm5aKev69TazfrkDbhfzx8=;
        b=vIMTrBv6Pdb/a+PWqQotzioeRRZmDA4byqu1x0cR46DyOVRrt7GPm5SgapyRilpbNG
         IiMMkbgUOHqQhCwJ1zqZug7u0NRU50cND9pleYJMsHaUzoa2uctPW42Q1WDqgBd7K88O
         ZV/ynoimuwf+68fcdFV5XOj7+d93MqHNsAptz1Rfo9SgyYuw/lHGkh6X47QXnycuhNAI
         F2G2teUP2wZB/o1ZJhuvmr0PHfXR9zc9ZWeNTr4Q5oEA+SE9S5nfshcR2UjQPAYThC/b
         vlZcPl1UUZ3af3S1UltUFRaHBMvn/zfqdxCrv0ylWQ1Ycri85L0gcIBR5Fwh8oiPsMdy
         o9GQ==
X-Gm-Message-State: AOJu0YzGEkDdOhiGBf1FtFGTxMvyZ4dzZGe/E8lhFYIRlee/rHgnujVv
	2zpx361SeF0VJy/G4pELb/OYvQYuAAztzlG21HLg9fwtiWLxkjHo
X-Google-Smtp-Source: AGHT+IEQRY+VQJwcWbXcI9RruOd3Mk/ahfG2ijsnUjuj12vYIejPGvQdFB/INdprRs07A80Ym2y9dw==
X-Received: by 2002:a92:d20b:0:b0:360:a1f0:8dc with SMTP id y11-20020a92d20b000000b00360a1f008dcmr3239349ily.43.1705891636510;
        Sun, 21 Jan 2024 18:47:16 -0800 (PST)
Received: from fedora-laptop (c-73-127-246-43.hsd1.nm.comcast.net. [73.127.246.43])
        by smtp.gmail.com with ESMTPSA id k3-20020a02ccc3000000b0046eebcdda49sm166313jaq.102.2024.01.21.18.47.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 21 Jan 2024 18:47:16 -0800 (PST)
Date: Sun, 21 Jan 2024 19:47:11 -0700
From: Thomas Bertschinger <tahbertschinger@gmail.com>
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Trevor Gross <tmgross@umich.edu>, linux-bcachefs@vger.kernel.org,
	bfoster@redhat.com, Miguel Ojeda <ojeda@kernel.org>,
	rust-for-linux@vger.kernel.org,
	Benno Lossin <benno.lossin@proton.me>
Subject: Re: packed, aligned structs in bcachefs (was: Re: [PATCH TOOLS 0/2]
 convert main() from C to Rust)
Message-ID: <20240122024711.GC151023@fedora-laptop>
References: <pawxsqxbjncrwtxytattvgizwrtmkis6suokgkb6wfm5xvsnhd@njjz4ywheu2a>
 <20240115175509.GA156208@fedora-laptop>
 <iiraqelv6wtwxcdf2yjtjt26ghejngfantjx7d4mztav27qu7y@gmiztxamveq3>
 <20240115191022.GC156208@fedora-laptop>
 <z7ajmttuzbvtxn4onwoxph6mevqt2rje2nga6cpux73geffias@p5kk7pqnswf6>
 <CALNs47t6qjYZeQKC+ahAaG6iNDGGNe8o+Q8tKhpRynYLWL3R8Q@mail.gmail.com>
 <gpokpnqgj6c2pcmtpiu46jy3kb3tom4xkp3fykg26zx6e3c2qe@zrnl2653qwsk>
 <20240121161124.GA151023@fedora-laptop>
 <cxben4yqhrraso7fiw54hj7wr4minkvxm7ibsh2yl4zew62jpy@xrraic3ceqns>
 <20240121193253.GB151023@fedora-laptop>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240121193253.GB151023@fedora-laptop>

On Sun, Jan 21, 2024 at 12:32:53PM -0700, Thomas Bertschinger wrote:
> On Sun, Jan 21, 2024 at 01:19:24PM -0500, Kent Overstreet wrote:
> > On Sun, Jan 21, 2024 at 09:11:24AM -0700, Thomas Bertschinger wrote:
> > > I made a script to compare the size and alignment of bcachefs structs
> > > in C vs. in Rust generated by the patched, lossy bindgen. All sizes
> > > were the same, but the following types had different alignment:
> > > 
> > That right there is really good news. If we can add that script to the
> > tests in bcachefs-tools, we'll already be in better shape than we were.
> > 
> > I wonder if it would be possible to upstream that check into bindgen.
> 
> I did this with an awk script that grabs the structs from the bcachefs
> C headers and outputs code in Rust and C to dump the sizes and
> alignments. I then manually added calls to the generated functions into
> the bcachefs utility and diffed the output. I'll try to get this into a
> form more suitable for an automated test, and hopefully submit a patch
> to bcachefs-tools soon...

So after looking into bindgen more... it turns out that bindgen already
does this! All you have to do is run "cargo test" from the
bcachefs-tools/bch_bindgen/ directory.

Reading the documentation helps :)

The bindgen tests basically agree with my findings, that struct bkey
gets the wrong alignment (4 instead of 8). There's one other problem
that follows from this, btree_iter.k (a struct bkey) gets the wrong
offset.

Manually adjusting struct bkey to use #[repr(align(8))] as described
previously fixes both of these problems.

The other problem types mentioned earlier, bch_extent_crc32 and
bch_extent_ptr, are handled manually outside of bindgen so they don't
show up in the bindgen test. However, they can be moved under bindgen
control and fixed with the same technique, using align(8) instead of
packed(8).

This works immediately for bch_extent_crc32 but bch_extent_ptr is a
little trickier. It is a member of struct btree_node which has a
"packed" attribute so we run into rustc disallowing embedding aligned
types within packed types. Luckily, replacing the packed(8) attribute
on struct btree_node with align(8) appears unproblematic.

Given all that, I think it should be possible to move forward with an
unpatched bindgen as long as we're OK with treating a few types 
specially. We can move all of the above types under bindgen control (so
that they are covered by the automatic tests) and post-process the
bindgen output, as suggested in this comment [1], and use align(8)
instead of packed(8) for these types. 

What do you think?

[1] https://github.com/koverstreet/bcachefs-tools/issues/202#issuecomment-1886962791

- Thomas Bertschinger
