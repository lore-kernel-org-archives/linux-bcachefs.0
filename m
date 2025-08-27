Received: from out-170.mta0.migadu.com (out-170.mta0.migadu.com [91.218.175.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37590747F
	for <linux-bcachefs@vger.kernel.org>; Wed, 27 Aug 2025 17:17:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756315079; cv=none; b=ZXbfZN+/lTsfpDsAvIWxhv8j8VX4ZzxOzhLO2yWrKBe01Pe/bFHlNNdntgBfZlEueQSxF56986VKvbWLPeBTXxvduA2xuIC9ji/S1YzMUfKiJFICqKpM53KyhSBXJ8O+Fhj3gpk51CB4h83LB0+QunWBXb17ZJ5lfJSU69xUr4g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756315079; c=relaxed/simple;
	bh=xp9vOzpWvlWOH/vekTLfJdKtlKihSdaXejnf3eKJ4oU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PBN00wJMIuj+s0IWK0jy5Zdz/C73ylkGjiqtJErt6j59MXrMK00vtZ6FJwTA3JMOBYltqfdgymrqrBZP7g4qkj5Uvmh2U0pFpz7nTXJ81OAtKkzN2MYVd618WByp76ApJT4Qg2lUbs867ppIdR4CoSFC6vFb8QeCsu5neZkd5e4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=GoIxIbU8; arc=none smtp.client-ip=91.218.175.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="GoIxIbU8"
Date: Wed, 27 Aug 2025 13:17:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1756315075;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=T8UCT/kQdrNZNquj7hG7MhZA/cGR0QDJs5kJCglL4BA=;
	b=GoIxIbU8rKz7rzEGoSR5P1zVeZX8Qsk4MrC2MUVCo1Faui4cFoRk/ZJdpVPx2gIp8pCJTm
	BQR7MmyYRFXc+OV42S3+cO9HwY/epdOvl6stfvLepoc0HrJ3FFb1zOciRbKOhYG/F/Uhwi
	Zmx0kmOZlmaU//BBN/5zEekGVWA6PbY=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: himikof@gmail.com
Cc: linux-bcachefs@vger.kernel.org
Subject: Re: [PATCH 00/12] Accounting for accurate progress reporting
Message-ID: <s46som5jamwnsmtyxzzp6kspjjkh7pfjpplerdmhdwp4pokvis@mg7qo7gdw4c5>
References: <20250827-better-progress-v1-0-74c24de7988a@gmail.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250827-better-progress-v1-0-74c24de7988a@gmail.com>
X-Migadu-Flow: FLOW_OUT

On Wed, Aug 27, 2025 at 01:49:06AM +0300, Nikita Ofitserov via B4 Relay wrote:
> This patch series introduces new per-btree accounting counters and uses
> them for (hopefully) accurate progress reporting in recovery passes.
> Also includes various assorted bugfixes.
> 
> The first commit ("Relax restrictions on the number of accounting 
> counters") is optional, but will likely greatly improve the 
> upgrade/tools version mismatch experience. Without it, all bree usage 
> accounting will be thrown out and rebuilt on any version mismatch.
> 
> The second commit has the format change but does not contain the
> upgrade/downgrade table entries. It is intended to be integrated
> together with other accounting changes in a single version upgrade.
> 
> The last four commits are drive-by fixes/improvements, especially 
> "Improve check_allocations pass speed not in fsck", which should make
> the future accounting upgrades much faster.

Series looks good, except for a couple notes:

- I prefer bugfixes/refactorings to come at the start of a series, so we
  can get them in right away; I try to push on disk format changes as
  far back in the series as I can

- The nr_counters check you deleted in bkey_validate has
  upgrade/downgrade considerations, old versions will blow away the
  btree counters on downgrade. That means we have to add a downgrade
  table entry and run check_allocations, on both upgrade and downgrade

- As noted on IRC, by default all on disk format changes with only very
  simple exceptions should get a new on disk format version; it helps
  document what changed and it's good hygiene - version numbers are
  cheap

- We should probably think more about upgrade/downgrade testing: I have
  upgrade/downgrade tests, but they're not automated since they require
  disk images that the CI doesn't know about
