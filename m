Received: from out-179.mta0.migadu.com (out-179.mta0.migadu.com [91.218.175.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E46D1BC2A
	for <linux-bcachefs@vger.kernel.org>; Thu, 12 Jun 2025 15:17:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749741451; cv=none; b=laRFwN/mvw7+FiB0wRxdPUHFPLTv2wrsORcUkRqsVzhNsyD348XJr80j2uN2DoMbFcOSv1+IUJ/nAYLALxNFNERMia8ckB/Xq2rkQU4mG7sLYAzwMOTCmOSmrxE6khpDbD8vCiUb/TY5LPrxu7TB+6CFhgzOZuzdi9aUEaLLSFA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749741451; c=relaxed/simple;
	bh=DHSLDlwJgLmVaxjY7Tq+YJkKRXtHvrkI26fE1hrYVSU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OWTCLSdbgUy0uc0hhWbs+YfZUA2Tbhm6xMnDBMhHiOGF4IWjJZ3gffpBGDzyX4DX9dXy0iKWGyJAKvDJuMsjF+kY7BP+DXNtwwu9CL2gzydu+4zdkh79zMJIDOT6jL5UiMbPJNDDvJvk61UVDMYOg97EAqf0MQYcq8SqgYExtOQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=bafVoL4O; arc=none smtp.client-ip=91.218.175.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="bafVoL4O"
Date: Thu, 12 Jun 2025 11:17:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1749741445;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3CG/jv0idb75K4SHWQbg9B29rnNnSehWjTkdb2eMS5w=;
	b=bafVoL4OFBiMd1lSdFFmVucipuAfuKJfdTRCdtt9KF9eYXVRv4U3BfVcT8ibv5IvKD6/3k
	ABwLiJKGmDv2E/MN9NOQ8WG9lX+AwL7QzzemDjQ63JvrT9Y+DhuQxzX1Xw5rln/IawSFnQ
	qBt9eMG26QUMbRXLLu9nm8LhaZXPmu0=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Martin Steigerwald <martin@lichtvoll.de>
Cc: linux-bcachefs@vger.kernel.org, Hongbo Li <lihongbo22@huawei.com>
Subject: Re: Size of directory entry 16 EiB according to "ls -l"
Message-ID: <sckkunsdfsvkynpfh6rknpe3rggag6mcc5gkqypz3kvhi7x4cu@wkz2iepbn3o5>
References: <3009813.e9J7NaK4W3@lichtvoll.de>
 <2229760.irdbgypaU6@lichtvoll.de>
 <5etvxpcqguoxh6trjsvxk2pfjap5otsj5kf7ioz67fznhlgzi6@vav7ef3xpyww>
 <3358454.aeNJFYEL58@lichtvoll.de>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <3358454.aeNJFYEL58@lichtvoll.de>
X-Migadu-Flow: FLOW_OUT

On Thu, Jun 12, 2025 at 04:30:08PM +0200, Martin Steigerwald wrote:
> Kent Overstreet - 12.06.25, 15:45:23 CEST:
> > > I suppose I could just create a new directory and move over the files
> > > from the one with the odd size.
> > > 
> > > However, keeping as is for now. Maybe I can help testing repair code.
> > > 🙂
> > Well, I do need to work on making the rest of the fsck passes work
> > online, maybe I'll be able to start on that soon... fingers crossed 🙂
> 
> Would you like me to wait for that for testing?

No, that won't be for ~months, most likely. You'll just need offline
fsck to repair this for now.

(check_inodes() shouldn't be too bad to make work online, I've just got
filesystems to recover and projects to finish before I start new things)
