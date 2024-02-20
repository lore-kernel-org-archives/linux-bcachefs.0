Received: from out-180.mta1.migadu.com (out-180.mta1.migadu.com [95.215.58.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F4B814F9C8
	for <linux-bcachefs@vger.kernel.org>; Tue, 20 Feb 2024 21:26:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708464405; cv=none; b=Vjl46YRfpRVpRbTFc9RplG/UPtIjQqtm8H8qHLf+jC4rwzofUa1DDAMB7KKFhQ0Uer8D860Ci0WgYj4gWF2hXuKzlJ1X+PQKW3YYigWTBiz5X2E+TeQNPIYHM2Gc3KkghGfn0SiRWJWgjk6k88yH7X/PFiTfOrBn4iwTeqNMdQo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708464405; c=relaxed/simple;
	bh=OnvxZBOcM/Q92asmFkwp81+uZn+vRE6bDy9x2IugkxA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Uf9sl8eK48t3HshYLuSr3B0gt/pGLIwDShho8V3PIMvoyZebSOsqgMQCjGzbOfofEiSKPgbtowQQNKlIeiZrE8ODyod9uVmdRmuZ4tg9WbA+Ps59pFEfTZ/7YGJmAaSqgTnleYhWui0WxkjLy80yTZ21sNNYAFxAlOpQc+nuQoY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=opuP2K4Y; arc=none smtp.client-ip=95.215.58.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="opuP2K4Y"
Date: Tue, 20 Feb 2024 16:26:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1708464401;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=2idwVrm4JeQeZXYLVGMPksgP6HQJHdS89iFs6IHBKhg=;
	b=opuP2K4YmLYrSUA6lxj+u55KHdY12hdCh41lpMPiIYTtFKA2hb4BXavoq8eHvWXftQFn2m
	2cjIBOdJJfzN/aHbvgZ1Phtq0UbkpMCz5ZtWyBiXrE+wVchtN+1BYshGavVtKcJ/g42kIF
	JHj3qxPYSxiYR+nI+Ao9sUqwTmoo4ng=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Dan Carpenter <dan.carpenter@linaro.org>
Cc: kent.overstreet@gmail.com, linux-bcachefs@vger.kernel.org, 
	smatch@vger.kernel.org
Subject: Re: [bug report] bcachefs: missing error checks for
 bio_alloc_bioset()
Message-ID: <oxbjbtdx4go62bkdeclz45iw2tmtumkeplillsntifhm7prjfo@q3xmjmo4ok7s>
References: <0c35596b-a280-40df-946c-c50574c3ce26@moroto.mountain>
 <fufpv24643xxn3a5jpfxx4wbfwlczrhjyzqkxo33be3yeb4sea@y4obfahio6ag>
 <11e692bc-4077-4e82-b680-fa86182d15d9@moroto.mountain>
 <34p5j77iamkybfexdpjslxegy74da7mjtpsssrv4mems4bo5mj@5xlpdnvm4yxz>
 <e92fc993-ab94-4f3b-9ee2-4e0ca5341720@moroto.mountain>
 <uxyjkjzbur2unpdkt5yl2bojacg4tptfj6k4zyshcyvyfun3i7@y6q267iebdgg>
 <a1d5fc7c-87ac-45f5-8f3d-5af1b7cd3614@moroto.mountain>
 <jno3abkiamnwk7nqh7ojvzvrurk2ua7q3fkhnhugsxdh5vjkbh@a43f35palmkn>
 <b1167150-77ee-414c-9858-50e8c90dbd6e@moroto.mountain>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b1167150-77ee-414c-9858-50e8c90dbd6e@moroto.mountain>
X-Migadu-Flow: FLOW_OUT

On Tue, Feb 20, 2024 at 02:39:35PM +0300, Dan Carpenter wrote:
> On Thu, Feb 01, 2024 at 05:45:38AM -0500, Kent Overstreet wrote:
> > Smatch would be more useful to me if I could just run it myself, in my
> > own CI, and get results back for new code when I get the rest of my test
> > results, instead of getting yanked out of my flow a week later to go
> > abck and look at code I thought I was done with.
> 
> Programming Smatch is quite difficult but running Smatch is fairly easy.
> It's documented in Documentation/smatch.txt.
> 
> To test the kernel it's just:
> ~/path/to/smatch/smatch_scripts/test_kernel.sh
> 
> Or to just test the parts you are interested in the it's:
> ~/path/to/smatch/smatch_scripts/kchecker fs/bcachefs/
> 
> To build the database takes maybe six hours but it's also easy enough.
> ~/path/to/smatch/smatch_scripts/build_kernel_data.sh

Well, the last time I tried smatch it wouldn't build out of box, and it
took a solid day to figure out that it was an llvm version mismatch when
I didn't seem to even need llvm.

I'm not asking for distro packages here, but it'd be cool if I could
integrate it into my own CI system.

> The main issue is that I'm always writting new code.  And sometimes that
> code is bad.  Or sometimes I'm using a heuristic to find buggy code and
> it works but not well enough to publish.  For example code like:
> 
> 	if (!ret)
> 		return ret;
> 
> I would estimate that in new code that's going to be buggy 5-10% of the
> time.  (Obviously after we fix the bugs it's 100% false positives).  I
> review code like this but I try to avoid publishing checks where there
> is a more than 50% false positive rate.
> 
> So right now I only have two bcache warnings.  The missing error code
> warning isn't published unfortunately...  I don't think I'm going to
> have a lot of time to dedicate to this stuff in the up coming months
> honestly.

Why not just put this stuff up in a dashboard? Make it easy for people
to see the full results for their code, without nagging them with a
separate email for every warning?

> fs/bcachefs/journal.c:575 __journal_res_get() error: uninitialized symbol 'can_discard'.

your error message seems wrong to me. If it was an uninitialized
_symbol_, i.e. that symbol didn't exist, then the code wouldn't build.
Instead you seem to be warning about a possibly uninitialized variable.

Yet a cursory inspection reveals the variable is initialized in every
path before it's used, and gcc gets it right.

> fs/bcachefs/alloc_background.c:1751 bch2_discard_one_bucket() warn: missing error code here? 'discard_in_flight_add()' failed. 'ret' = '0'

No idea what smatch is complaining about here, we're returning either
-EEXIST the error code of darray_push().
