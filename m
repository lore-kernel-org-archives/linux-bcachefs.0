Received: from out-187.mta1.migadu.com (out-187.mta1.migadu.com [95.215.58.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E49D0180A65
	for <linux-bcachefs@vger.kernel.org>; Wed, 17 Jul 2024 13:38:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721223541; cv=none; b=V9AHWAuNSZAy5I86pisDvlT7kv9u2ECQ2jP8JmUINliXqzfk1PUS79s88eV96ROdPL6nlVfE4hF+VSmdLnbufYR12sn34ShlQflRBdivg/nMD8qQ+9+6LWgVREU1Yc4ICHAi0kj2vT2jvdZkmAQtQXMWk4LdFFJIKSGWFhyVnW8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721223541; c=relaxed/simple;
	bh=m+mTbweVQcGqbqpPzpMvJHMowDSQh5L6Zf8j5RoDrvc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=O1ViuOxZxX2TMUo5cRXR+grvtz6bt6dEokWMKdAAKiPSXRHHdRlGhByTm7+6B9YwU16SNEPQMiJSNWGgqWF1+liLYL05an+KtLGcl25gE3vCHslNV3RVrJHpTKTV/q3V1X7s24WH4CQ+O8qUSfot/+sBZ7/gJYtgcStxw2WxA0w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=hPUhphbx; arc=none smtp.client-ip=95.215.58.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="hPUhphbx"
X-Envelope-To: lihongbo22@huawei.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1721223535;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=4gQRiizowEFRr0CbWWyac5+JBFuxmn8RvoOhJZw4qKM=;
	b=hPUhphbxOEChxnZU6DUDpn8KZdPAbuk1YpYtsd5H05GZMsqZ1/SkMKM/rDaAmOIdmOxRGs
	ZnvUwG77fYeXHDfL4IqYNCgmPuuum4DyEfD4laSZwQbMqq8v3Fqv9C7pngyy4GE0kBCkaf
	kyjpq+Wfbu9t5h0AV0HkF9znQFQrqgQ=
X-Envelope-To: linux-bcachefs@vger.kernel.org
Date: Wed, 17 Jul 2024 09:38:53 -0400
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Hongbo Li <lihongbo22@huawei.com>
Cc: linux-bcachefs@vger.kernel.org
Subject: Re: Suggestions for the bcachefs community
Message-ID: <z6pwyj3w7u5etmzrubglx2ipnavpguxui3wvwjxjci6m5j4ots@upnbrzwtg4yl>
References: <bfb96546-cf04-421b-b876-2017d20d323f@huawei.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bfb96546-cf04-421b-b876-2017d20d323f@huawei.com>
X-Migadu-Flow: FLOW_OUT

On Wed, Jul 17, 2024 at 11:12:14AM GMT, Hongbo Li wrote:
> Hi, Kent
>     I've noticed that the main change log for bcachefs has not been included
> in the release notes for the latest Linux 6.10, which may cause some
> confusion. I'm not sure if it's because you're too busy to publish some
> change logs, or if there are other reasons behind it. I thank it's necessary
> to work together with the bcachefs developers to build up the bcachefs
> community, keeping it in sync with the community development of other file
> systems. Of course, this depends on whether you can spare the time to
> contribute to this, and the efforts of the bcachefs developers can also be
> leveraged to accomplish this work.
> 
> Thanks,
> Hongbo

Published where?
