Received: from out-176.mta1.migadu.com (out-176.mta1.migadu.com [95.215.58.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DB773A287
	for <linux-bcachefs@vger.kernel.org>; Fri, 15 Mar 2024 17:57:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710525478; cv=none; b=KG2pb5bhcbXt3yxEu7MlDd4P2qbpoKxevyeJ0p80PIAEF2xkhMWtqtT/eltgY9n8ktWYn5eU+dBB/ZeE+DjGZOdc9KvQi57Mag/uRZscgmPnCCZS2GApNCt9HH/f8/tIGwn+rXL6tyeyoX5kv0qOsoOEpDOYvvaFScxeJG8akmw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710525478; c=relaxed/simple;
	bh=Tde7wUhRpbBGuZM3oOiKyK1trez4oUmQs71Ex8H8z2M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RCZ7HPUs1mvv9HZ9MEodmHAhDNh0kG2/Wc3wMt3PIsRRQPIgFj2F+41P76hfx8tjjbrdotjvr8yEUqXl5bt7IKukNb/YQzB9TnlZt8Mx0xOwWfa1oSDJFUqRpHI+az/17fR/IcNYQwrnKSRMn/UMRtXi5g5xKA0ThQdM8kjRZWs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=iybei6+S; arc=none smtp.client-ip=95.215.58.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="iybei6+S"
Date: Fri, 15 Mar 2024 13:57:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1710525474;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=CYt91xYMKuX7kjqLzNM222k1dBQGNYp7NSEMxGeVb7o=;
	b=iybei6+SK+x3HIrbiJQ55HRFeb0Ur1xxY66+l0+W6d4duKgfDSoZbz3ewcHHZvjDDFOmv8
	DjuYxPV80axbzmtgGvNqIh99rK49sAUT/MhLdvOZMc3vqXjYluSQqAw4Vwn63HeYnIAsGu
	KBXmfmOgmouqitHnbJ/ZfLenG5euKzY=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Martin Steigerwald <martin@lichtvoll.de>
Cc: linux-bcachefs@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Subject: Re: bcachefs: do not run 6.7: upgrade to 6.8 immediately if you have
 a multi device fs
Message-ID: <2c3smz5wnk5z2kaqyqbo6kr3bb6dtvanfvupsqdydggzmvkukc@xssb53m4lyey>
References: <muwlfryvafsskt2l2hgv3szwzjfn7cswmmnoka6zlpz2bxj6lh@ugceww4kv3jr>
 <12416320.O9o76ZdvQC@lichtvoll.de>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <12416320.O9o76ZdvQC@lichtvoll.de>
X-Migadu-Flow: FLOW_OUT

On Fri, Mar 15, 2024 at 09:57:34AM +0100, Martin Steigerwald wrote:
> Hi Kent, hi.
> 
> Kent Overstreet - 15.03.24, 05:41:09 CET:
> > there's a bug in 6.7 with filesystems that are mid upgrade and then get
> > downgraded not getting marked in the superblock as downgraded, and this
> > translates to a really horrific bug in splitbrain detection when the old
> > version isn't updating member sequence nmubers and you go back to the
> > new version - this results in every device being kicked out of the fs.
> 
> I take it that single device BCacheFS filesystems can be upgraded just fine?
> 
> I can also recreate and repopulate once I upgraded to 6.8. Still waiting a 
> bit.

No need to recreate and repopulate - you just don't want to be going
back to 6.7 from a newer version.
