Received: from out-183.mta1.migadu.com (out-183.mta1.migadu.com [95.215.58.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CA4A882B
	for <linux-bcachefs@vger.kernel.org>; Mon,  3 Jun 2024 01:49:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717379352; cv=none; b=k4CAttfe1PJdwpB3a/xE1xDphqgHF4J52AwnrVprj5ZvgWmZ0R5IJeyuqdXIXnPc5vupzcSSsuRiHNMwYw9Rf31RccIu3FZERs5Y6kvCzRLHYTa+iCjZxNu1RHYYfAwdvk89skzxNdOsnYZXIJ66BlW+tt8ciK4iDpB5uIaEaMA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717379352; c=relaxed/simple;
	bh=jc2oAHAgV+IWVZG09B/B8WzW/blv5ZelExL8kO3r+HE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RYZy+j5+yNYd9FaG6H2RCc26ar8X5+lKE1fX+jnT5B1vYl9jGKqqeZDUKWE6ZyBtg1Ixxpx9MVn5eFO0ax0L8ZgdNYFLGfDLOHvLalYKdwZ/1MH1RryRI74sGjwBTuuP3k4v56PFvi6cbJmjerlqxpQNTIgQ6T44fjlcVKE6z/A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=RjQEX0/E; arc=none smtp.client-ip=95.215.58.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="RjQEX0/E"
X-Envelope-To: reed@riley.engineer
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1717379347;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=iBV8QxsqMP2ig+dl73GyzPmKf5m5CpcNk6cUU1RzIxI=;
	b=RjQEX0/E8zucQa7evsciEfucrttBepBDLu/XWfD+6Y4yPACGhXvWJWLnLkVjg6Q69fmJ6L
	tJrYa0P6c5YiFJvtZdr+reuQQ0lbHEAVt2Lg5NZl9Mb3POWqi+55oZwEU9UCab+7kSplQq
	aepmAHwd1IXX3J6N1VqH+qzR84Sbs+0=
X-Envelope-To: bfoster@redhat.com
X-Envelope-To: linux-bcachefs@vger.kernel.org
Date: Sun, 2 Jun 2024 21:49:04 -0400
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Reed Riley <reed@riley.engineer>
Cc: Brian Foster <bfoster@redhat.com>, 
	"linux-bcachefs@vger.kernel.org" <linux-bcachefs@vger.kernel.org>
Subject: Re: [PATCH] bcachefs: support REMAP_FILE_DEDUP in
 bch2_remap_file_range
Message-ID: <75kgxfcinkjgiecyfprtfra7pwqseg37pnj2fwo2jww3eelhza@kehzdcpykr3o>
References: <yuG-zWAd7xX9SkysCfG2ELC8drJi3bxsagrf03hf2Aeah__0W1exPDJabqC23NyOzt5BXmYEF95045yO2SfCbZMgGkYqbycmlUIBZqk2vyE=@riley.engineer>
 <ZkIIxvdRKrgCdoC8@bfoster>
 <45_rwv0SgX9alyYyitLlz7CwOVmZZejtbJRAzqVyVnXjhVDxhPp273Pwd1Lpp3n1T-HsBT9EB1ZeXyoinExuozvfk4LNfTFHxa54NBJojOo=@riley.engineer>
 <ZkND7a95h3pzCrOq@bfoster>
 <IwehPOWRxy8vk3Mmm7whasvVfWWV7CsCpCiD7OqgrbIPP79B9T8XI3hQtiZvaWfWqxr6bqITfahle-YEeff1sOXioAMCdcYyjGDuNji2Ufo=@riley.engineer>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <IwehPOWRxy8vk3Mmm7whasvVfWWV7CsCpCiD7OqgrbIPP79B9T8XI3hQtiZvaWfWqxr6bqITfahle-YEeff1sOXioAMCdcYyjGDuNji2Ufo=@riley.engineer>
X-Migadu-Flow: FLOW_OUT

On Mon, Jun 03, 2024 at 12:05:36AM +0000, Reed Riley wrote:
> Any chance of getting this patch merged upstream?
> 
> I've been running with it on my system (and using the fideduperange
> ioctl fairly regularly) for a couple of weeks now with no issues.

Yep, applied
