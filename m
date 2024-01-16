Received: from out-172.mta0.migadu.com (out-172.mta0.migadu.com [91.218.175.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C23201CD24
	for <linux-bcachefs@vger.kernel.org>; Tue, 16 Jan 2024 17:33:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705426439; cv=none; b=fgzfObJbk+mVcT9xtu1wWDXvIG6/DCFpzrwOLANVQbLtFyQ+m+3LLolVHXHaeZ7howpxmh9aYfKq2x2m2+Ml+i3QpREfOmMty/ZtgFInplcPide6XDlp87nLguaWFVpuhDJauwDxdaI3/K+Tlx6fRC8VGzcRKtlSrONuxOQL9k8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705426439; c=relaxed/simple;
	bh=WDHckDhPEgg9GHitxYpLCYTtOi/YHgWI/e0zmkiouCw=;
	h=Date:DKIM-Signature:X-Report-Abuse:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-Migadu-Flow; b=AMez65e7d+FkasxZUHI8+GCoqPuy+zThROakth4wOdn+vqhEWHgRTUZxS3aFgP4xIUp4VrX/9fvo6ShAtfif4HL3lr99IJZSN7fdIuoGVC/gPgh4Dddc0qLEWY/VKE4GO41XOX88QC1rEFFy6ErZ12jNPf4tWPVAI/z+ziSHg1E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=oCo3zAZ3; arc=none smtp.client-ip=91.218.175.172
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="oCo3zAZ3"
Date: Tue, 16 Jan 2024 12:33:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1705426435;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=SSV+Th9uGis0E2sTKcpqsct5I/1aSQ1j6woYRoV3Ta4=;
	b=oCo3zAZ3gxoXCZ4Di/g29ltG/4KGUHHeepsFV5nPnmA+TO5m0Rn7vsQiJpwtus3VPqXe3h
	ELnx8sCbpCFoEqZF/7yQhU1IIPaWpVlXCDrtI9e2IYg4Kynt5PdsKwXFX/F4WVTyIoJaT3
	7RxTAcTMWQZ3XdT68Sm+kHlfOty2vNI=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Brian Foster <bfoster@redhat.com>
Cc: linux-bcachefs@vger.kernel.org
Subject: Re: [BUG] general protection fault, probably for non-canonical
 address 0x280766500040001: 0000 [#1] PREEMPT SMP PTI
Message-ID: <dbqhxiv7kxbaeilxyyqzqqpjlaobxh262u7czkg5koec2w35p4@2oznjzf466no>
References: <ZaahtMNCEd42G3EP@bfoster>
 <ze74khldgkvbht5ryjq2bs5rjnm7eds2xytlwc76nqurjwf7tx@rpcyvnwbkglp>
 <Zaa74Ehk4idtZNwc@bfoster>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zaa74Ehk4idtZNwc@bfoster>
X-Migadu-Flow: FLOW_OUT

On Tue, Jan 16, 2024 at 12:24:48PM -0500, Brian Foster wrote:
> On Tue, Jan 16, 2024 at 12:03:09PM -0500, Kent Overstreet wrote:
> > On Tue, Jan 16, 2024 at 10:33:08AM -0500, Brian Foster wrote:
> > > Hi Kent,
> > > 
> > > JFYI, I'm seeing the following splat pretty reliably via generic/361 on
> > > an 80xcpu test box. The CI doesn't seem to produce this failure for
> > > whatever reason. This bisects down to commit 023f9ac9f70f ("bcachefs:
> > > Delete dio read alignment check"), before which the test still fails but
> > > the kernel doesn't explode.
> > > 
> > > Brian
> > > 
> > 
> > Can you test the following?
> > 
> 
> Still blows up... repeated a couple times to be sure.
 
That sounds like a driver bug then - what driver?
