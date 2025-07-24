Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB4C6223716;
	Thu, 24 Jul 2025 20:54:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753390491; cv=none; b=YYBO8/oH8EI4fJ9XLCoK9T/Siwz5QMoH8kqX0NsfocXbp4ZsbXPzndQIINnNQJz34L8ECjdl5vEQV0stcMtXj6eHdOcV7je0028xtcDPgxYbgXdLlXaJnPKgZvvIcQ7N0WWXaG8VtjCz/A4cdhJ434traS03F3NfyGlkw0LyucQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753390491; c=relaxed/simple;
	bh=333eNMy9efQ52/OsrjZbRQ4qrnhtfhiNmmgOwpbdFCY=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=K1mmK0KlD5glxqju9vlgp5UI78JAYVcV1L46ulRFIfUCfuBL9ntW96SKojOd4gLoDdaA2qy32228Qt9oPpLhYnDUWSvv2ie9dNS9mHzHVd9s6pkxYNSQEd4unYl1fvMl7inu8HCLhJJYRbjI1jRv7FAoN3ZD2bkIsmoVynonHSA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=fuRKHQ19; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="fuRKHQ19"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB4ADC4CEED;
	Thu, 24 Jul 2025 20:54:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1753390490;
	bh=333eNMy9efQ52/OsrjZbRQ4qrnhtfhiNmmgOwpbdFCY=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=fuRKHQ19U4p1ELWKTJP8ERI1j7+vUo99yHH7Y1Gy/Rm8KxZ65RkaDw7OMdJZA15tE
	 7rFv75vdk/9dfYgXSqTJdAC1ujP1IMf5j2bFr4nb//bWcIgnxaYu1byM8iwoNwCWnd
	 7uJE1QbH6wta6xsOGa8cb0BwrsfGsn9CTIsH3u9Y=
Date: Thu, 24 Jul 2025 13:54:49 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Vitaly Wool <vitaly.wool@konsulko.se>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, Uladzislau Rezki
 <urezki@gmail.com>, Danilo Krummrich <dakr@kernel.org>, Alice Ryhl
 <aliceryhl@google.com>, Vlastimil Babka <vbabka@suse.cz>,
 rust-for-linux@vger.kernel.org, Lorenzo Stoakes
 <lorenzo.stoakes@oracle.com>, "Liam R . Howlett" <Liam.Howlett@oracle.com>,
 Kent Overstreet <kent.overstreet@linux.dev>,
 linux-bcachefs@vger.kernel.org, bpf@vger.kernel.org, Herbert Xu
 <herbert@gondor.apana.org.au>, Jann Horn <jannh@google.com>, Pedro Falcato
 <pfalcato@suse.de>
Subject: Re: [PATCH v13 0/4] support large align and nid in Rust allocators
Message-Id: <20250724135449.2cb6457b90926cce1b903481@linux-foundation.org>
In-Reply-To: <20250715135645.2230065-1-vitaly.wool@konsulko.se>
References: <20250715135645.2230065-1-vitaly.wool@konsulko.se>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 15 Jul 2025 15:56:45 +0200 Vitaly Wool <vitaly.wool@konsulko.se> wrote:

> The coming patches provide the ability for Rust allocators to set
> NUMA node and large alignment.
> 
> ...
>
>  fs/bcachefs/darray.c           |    2 -
>  fs/bcachefs/util.h             |    2 -
>  include/linux/bpfptr.h         |    2 -
>  include/linux/slab.h           |   39 ++++++++++++++++++++++---------------
>  include/linux/vmalloc.h        |   12 ++++++++---
>  lib/rhashtable.c               |    4 +--
>  mm/nommu.c                     |    3 +-
>  mm/slub.c                      |   64 +++++++++++++++++++++++++++++++++++++++++--------------------
>  mm/vmalloc.c                   |   29 ++++++++++++++++++++++-----
>  rust/helpers/slab.c            |   10 +++++----
>  rust/helpers/vmalloc.c         |    5 ++--
>  rust/kernel/alloc.rs           |   54 ++++++++++++++++++++++++++++++++++++++++++++++-----
>  rust/kernel/alloc/allocator.rs |   49 +++++++++++++++++++++-------------------------
>  rust/kernel/alloc/kbox.rs      |    4 +--
>  rust/kernel/alloc/kvec.rs      |   11 ++++++++--
>  15 files changed, 200 insertions(+), 90 deletions(-)

I assume we're looking for a merge into mm.git?

We're at -rc7 so let's target 6.17.  Please resend around the end of
the upcoming merge window?

