Received: from out-175.mta1.migadu.com (out-175.mta1.migadu.com [95.215.58.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68A4B12DDAE
	for <linux-bcachefs@vger.kernel.org>; Fri, 24 May 2024 15:28:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716564541; cv=none; b=nSPGhhOoKNZQdH6+GbF87GdbSh6dvWFjZVjMbVCE1ywUI08fFJduLsxokr9QzspIQY3a8b42xHpa8R4SJIgjlcZAkGKDRGgSAL3ZHFg2B8FQrXScLd6lsFH1+rQsmApKY7bbMqexw6WOpgMgRMkYahw5fbdUikvfKfNpDusj6KA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716564541; c=relaxed/simple;
	bh=ZrwkY7OA74VPWeSi0lczYx2yoEjce3Xx1fX5oGEkMso=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fksGLgPqb+PvcOabJs6yjC826jJh6dP0FAvgi5Y5L0Vd3kMEGuEhLn6T0CA/u4pw6Uj4O0YJBfxfctRnKeAququyRf2vbxPe49rJ1u1IXzoWrUQh7+ataC7F7CKRYlsAvbMizQssQKpPFbd7jczlzYwBgLEJMIcbnxugzOasvMc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=F5J4VWSt; arc=none smtp.client-ip=95.215.58.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="F5J4VWSt"
X-Envelope-To: mathieu.desnoyers@efficios.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1716564537;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=irywiOY5cPEy6qsO/OYQSwObBpFKOwGsd5mBaePILQA=;
	b=F5J4VWStavQIRb2LNU1s+W29wn72CfvGB170e/PtHoEA2FnFyjfXjBnI/sEFRvwuzIV1+D
	Klnwitr49HjGYUEHUdFmkKTe1lw0cEhFvJxAlVlcagFvtrXFWuiukj72BmR6XG/GWcj2DO
	mcVG+g98Wi0laMkf3yg7sQrdthKE6nI=
X-Envelope-To: bfoster@redhat.com
X-Envelope-To: keescook@chromium.org
X-Envelope-To: linux-kernel@vger.kernel.org
X-Envelope-To: linux-bcachefs@vger.kernel.org
Date: Fri, 24 May 2024 11:28:54 -0400
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Brian Foster <bfoster@redhat.com>, Kees Cook <keescook@chromium.org>, 
	linux-kernel <linux-kernel@vger.kernel.org>, linux-bcachefs@vger.kernel.org
Subject: Re: Use of zero-length arrays in bcachefs structures inner fields
Message-ID: <vu7w6if47tv3kwnbbbsdchu3wpsbkqlvlkvewtvjx5hkq57fya@rgl6bp33eizt>
References: <986294ee-8bb1-4bf4-9f23-2bc25dbad561@efficios.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <986294ee-8bb1-4bf4-9f23-2bc25dbad561@efficios.com>
X-Migadu-Flow: FLOW_OUT

On Thu, May 23, 2024 at 01:53:42PM -0400, Mathieu Desnoyers wrote:
> Hi Kent,
> 
> Looking around in the bcachefs code for possible causes of this KMSAN
> bug report:
> 
> https://lore.kernel.org/lkml/000000000000fd5e7006191f78dc@google.com/
> 
> I notice the following pattern in the bcachefs structures: zero-length
> arrays members are inserted in structures (not always at the end),
> seemingly to achieve a result similar to what could be done with a
> union:
> 
> fs/bcachefs/bcachefs_format.h:
> 
> struct bkey_packed {
>         __u64           _data[0];
> 
>         /* Size of combined key and value, in u64s */
>         __u8            u64s;
> [...]
> };
> 
> likewise:
> 
> struct bkey_i {
>         __u64                   _data[0];
> 
>         struct bkey     k;
>         struct bch_val  v;
> };
> 
> (and there are many more examples of this pattern in bcachefs)
> 
> AFAIK, the C11 standard states that array declarator constant expression
> 
> Effectively, we can verify that this code triggers an undefined behavior
> with:
> 
> #include <stdio.h>
> 
> struct z {
>         int x[0];
>         int y;
>         int z;
> } __attribute__((packed));
> 
> int main(void)
> {
>         struct z a;
> 
>         a.y = 1;
>         printf("%d\n", a.x[0]);
> }
> delimited by [ ] shall have a value greater than zero.

Yet another example of the C people going absolutely nutty with
everything being undefined. Look, this isn't ok, we need to get work
done, and I've already wasted entirely too much time on ZLA vs. flex
array member nonsense.

There's a bunch of legit uses for zero length arrays, and your example,
where we're not even _assigning_ to x, is just batshit. Someone needs to
get his head examined.

> So I wonder if the issue reported by KMSAN could be caused by this
> pattern ?

Possibly; the KMSAN errors I've been looking at do look suspicious. But
it sounds like we need a real fix that involves defining proper
semantics, not compiler folks giving up and saying 'aiee!'.

IOW, clang/KMSAN are broken if they simply choke on a zero length array
being present.
