Received: from out-171.mta0.migadu.com (out-171.mta0.migadu.com [91.218.175.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EE8D15B99C
	for <linux-bcachefs@vger.kernel.org>; Thu,  1 Feb 2024 10:45:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706784347; cv=none; b=Q/eOfpqHEVwBpy9RsoFAcFB83myZwyCuiPgtaVgIkSigaL8jpjazNMySHpxwAbX2VJlZrIDEckUjKKdxcfMfAcm0YZ2HWejbnqOo7TcbpDhfpxVq0tpoGC/2tSAhkVhWT8TYuFRANiru7G8h1cFAq2Qb7pjJi6iLIn9jMm7oQBk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706784347; c=relaxed/simple;
	bh=J0t7rClXWHNYuFPtwz8vWADqFjxKpPUtEQvcXLuOJfw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DV7gnW1YKMCwb/bbK5YJwAU0jju0S5lb2f/Ze+yl5BtliFPKWXgXhsIixovzOdcXt7dd0mdG3mqspGFjGJgQo/xgjiHSHr6AUzjx0woWoES2BKmCb8wwapX/xYhM2iqei2vHJ3ZU0ins90G0yXfY5JrFc5JqIoD4UmJYEKy/+f8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=m/1TJ8RD; arc=none smtp.client-ip=91.218.175.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="m/1TJ8RD"
Date: Thu, 1 Feb 2024 05:45:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1706784341;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=tk33w22SDzrclLIAn3uzxhoBgMzFAZpu4hyaQ441cBg=;
	b=m/1TJ8RD35QYW35iGy/M92m29LSrwqPVdyiOIAIXtbbnmgviGVI8pNfag0C4YyStyvaRD+
	NCU7wj14K8OAIAddvwdFmrE/C85uzOZO+ch0Km+5kInMgp2IKuoLOo8hGPYXqjK5X4W2og
	sqy5Rk/bzC8ks2BFeS108QZcLJQubgk=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Dan Carpenter <dan.carpenter@linaro.org>
Cc: kent.overstreet@gmail.com, linux-bcachefs@vger.kernel.org
Subject: Re: [bug report] bcachefs: missing error checks for
 bio_alloc_bioset()
Message-ID: <jno3abkiamnwk7nqh7ojvzvrurk2ua7q3fkhnhugsxdh5vjkbh@a43f35palmkn>
References: <0c35596b-a280-40df-946c-c50574c3ce26@moroto.mountain>
 <fufpv24643xxn3a5jpfxx4wbfwlczrhjyzqkxo33be3yeb4sea@y4obfahio6ag>
 <11e692bc-4077-4e82-b680-fa86182d15d9@moroto.mountain>
 <34p5j77iamkybfexdpjslxegy74da7mjtpsssrv4mems4bo5mj@5xlpdnvm4yxz>
 <e92fc993-ab94-4f3b-9ee2-4e0ca5341720@moroto.mountain>
 <uxyjkjzbur2unpdkt5yl2bojacg4tptfj6k4zyshcyvyfun3i7@y6q267iebdgg>
 <a1d5fc7c-87ac-45f5-8f3d-5af1b7cd3614@moroto.mountain>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a1d5fc7c-87ac-45f5-8f3d-5af1b7cd3614@moroto.mountain>
X-Migadu-Flow: FLOW_OUT

On Thu, Feb 01, 2024 at 01:00:10PM +0300, Dan Carpenter wrote:
> This email thread has gone very badly and I'm definitely 50% responsible
> for that.  I apologize.

No need to apologize; conflict between ideas is inevitable, and it's not
a bad thing provided we can keep the discussion focused on the
essentials.

> On Wed, Jan 31, 2024 at 01:57:58PM -0500, Kent Overstreet wrote:
> > On Wed, Jan 31, 2024 at 09:43:14PM +0300, Dan Carpenter wrote:
> >
> > > Come on Kent, don't pretend like I haven't pointed out over a dozen
> > > bcachefs bugs since it was merged...  I'm just saying the comments
> > > weren't obvious here.
> > 
> > Most of them weren't real bugs, just places where I tweaked the code to
> > please the static analyzer; I believe the number of actual bugs was more
> > like 3-4.
> > 
> 
> That's not true...  I really try avoiding make the static checker happy
> patches.
> 
> The only one I see which was obviously just to make the checker happy
> is commit 4b33a1916a35 ("bcachefs: bch2_ioctl_disk_resize_journal():
> check for integer truncation") here was my bug report for that:
> https://lore.kernel.org/all/3b879f4f-2fe4-4e0f-aeeb-1d5a62d0a1ce@moroto.mountain/
> 
> There were three other patches where it was like we have an "if (ret)"
> but the "ret = " assignment was accidentally left off, but I consider
> those real bugs because obviously the "ret = " assignment wasn't left
> off deliberately.

The list of patches, and what the ratio of real fixes bugs/fixes is, is
honestly not really the relevant point here.

The issue is that it comes in as a trickle, and they all require thought
and back and forth on the list to address given your current workflow,
and they are _not_ high priority bugs - I could safely leave all of them
for the next six months and then address them all at once, given
everything else I have on my plate right now.

But because this is a tool that only you can effectively run, you're
forcing me into your workflow, and that is where I have to put my foot
down. This is _not_ an efficient way of working - and sharing the
results of your tool and not the tool itself is also not terribly in
line with the whole open source thing that the rest of us are doing
here. I'm going to great lengths to make my own code understandable and
useful to end users and other engineers, _not_ something only I can run.

Smatch would be more useful to me if I could just run it myself, in my
own CI, and get results back for new code when I get the rest of my test
results, instead of getting yanked out of my flow a week later to go
abck and look at code I thought I was done with.

I hope that clarifies where I'm coming from.

Cheers,
Kent
