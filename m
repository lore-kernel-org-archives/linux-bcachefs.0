Received: from out-173.mta1.migadu.com (out-173.mta1.migadu.com [95.215.58.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0661E2F44
	for <linux-bcachefs@vger.kernel.org>; Thu,  5 Sep 2024 04:26:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725510378; cv=none; b=nG9zFTIYM2fFYVPuBw3gUXu8hF7RTlgCsuPz173rWo6YTan3VWG2JCyxTaWq563ru9+V+KybOb1G12reKurq5IdFHbyhUQkw0RwowqHpg6ylbzxXJGBzG2cfGgJGn/t2Lx8PgvfmoYYY9oQg5BPdQBiLfAjkHv9IAtPemtfhX0w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725510378; c=relaxed/simple;
	bh=JDiJriQOsSjqYTgO6CGcINNnDcQDnQci+Dh9TCs3ky0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZpQhSK6H04YiJQ0KQWVkj0C1Iz2Va0TeIt8ZexEVfxXzBJELSTxiCEroFnCPXCie8EcLTBzzVFTFA4DgUulokqoC0VUBj+7y9+1wLKmQGE35S2KQwatHJnOmnsCa/zBAzgQVBBqaqeCkaZ786yolwRdrhp3DHADkZemPfsfCQkU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=KhFBw2td; arc=none smtp.client-ip=95.215.58.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="KhFBw2td"
Date: Thu, 5 Sep 2024 00:26:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1725510373;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=lFmB0YdptJaMSJg558EWPyTwDghbh83+8VHE90A76kQ=;
	b=KhFBw2tdgsHqAJlEiQDWYn4OHR0k8WI44IZd4fqI8yIx525CCTl2cPOBENDnDbiKt9QaEc
	mZd6VI5BJkalhnG/ZyS6G0jD0LtHiZ1LTdUdwVUm+RBoA+QGw5QSdcPBfu3kFAFBJfN1DR
	TikQL9fWWCut5nao2uy/T8FcGHV8JQc=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: David Wang <00107082@163.com>
Cc: linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [BUG?] bcachefs: keep writing to device when there is no
 high-level I/O activity.
Message-ID: <xzz5l6mvyyoqcjx7t5tq4hznqyhmyec3fqfcqoxyqvbecmribc@4vw3gnt5b46d>
References: <20240827094933.6363-1-00107082@163.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240827094933.6363-1-00107082@163.com>
X-Migadu-Flow: FLOW_OUT

On Tue, Aug 27, 2024 at 05:49:33PM GMT, David Wang wrote:
> Hi,
> 
> I was using two partitions on same nvme device to compare filesystem performance,
> and I consistantly observed a strange behavior:
> 
> After 10 minutes fio test with bcachefs on one partition, performance degrade
> significantly for other filesystems on other partition (same device).
> 
> 	ext4  150M/s --> 143M/s
> 	xfs   150M/s --> 134M/s
> 	btrfs 127M/s --> 108M/s
> 
> Several round tests show the same pattern that bcachefs seems occupy some device resource
> even when there is no high-level I/O.
> 
> I monitor /proc/diskstats, and it confirmed that bcachefs do keep writing the device.
> Following is the time serial samples for "writes_completed" on my bcachefs partition:
> 
> writes_completed @timestamp
> 	       0 @1724748233.712
> 	       4 @1724748248.712    <--- mkfs
> 	       4 @1724748263.712
> 	      65 @1724748278.712
> 	   25350 @1724748293.712
> 	   63839 @1724748308.712    <--- fio started
>   	  352228 @1724748323.712
> 	  621350 @1724748338.712
> 	  903487 @1724748353.712
>         ...
> 	12790311 @1724748863.712
> 	13100041 @1724748878.712
> 	13419642 @1724748893.712
> 	13701685 @1724748908.712    <--- fio done (10minutes)
> 	13701769 @1724748923.712    <--- from here, average 5~7writes/second for 2000 seconds
> 	13701852 @1724748938.712
> 	13701953 @1724748953.712
> 	13702032 @1724748968.712
> 	13702133 @1724748983.712
> 	13702213 @1724748998.712
> 	13702265 @1724749013.712
> 	13702357 @1724749028.712
>         ...
> 	13712984 @1724750858.712
> 	13713076 @1724750873.712
> 	13713196 @1724750888.712
> 	13713299 @1724750903.712
> 	13713386 @1724750918.712
> 	13713463 @1724750933.712
> 	13713501 @1724750948.712   <--- writes stopped here
> 	13713501 @1724750963.712
> 	13713501 @1724750978.712
> 	...
> 
> Is this behavior expected? 

We've got tracepoints and counters (in sysfs) for checking what's doing
the writing.

If it's a moderate amount of IO, it's probably journal reclaim; it
trickles out writes if the journal has room (it's trying to spread out
bursty work). If it's a lot of IO, it might be a bug.

Changing journal reclaim behaviour (and other background tasks) is on
the todo list, the current behaviour is not great for machines where we
want to "race to idle" to save power.
