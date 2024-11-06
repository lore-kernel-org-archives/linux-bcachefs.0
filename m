Received: from out-185.mta1.migadu.com (out-185.mta1.migadu.com [95.215.58.185])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86CD520969B
	for <linux-bcachefs@vger.kernel.org>; Wed,  6 Nov 2024 19:34:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.185
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730921670; cv=none; b=F/mgDg41oMlKNzi6xraX35FxD7dWgUdzLlJbMOD5DSX7OLN+Q1nfoT84Vx2UXENUOAQnnx9k2rSYGXrEvsrkoZGKGrW6WUC3GlbCwkiNbC0CZBYu8lOEco4EpIwvCiMafVEFaFc1hEPPQROfImTC2OSvd1KEn3biwbcf1fWaiHM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730921670; c=relaxed/simple;
	bh=qRfQy4Z3PjLO6M9IimzLtymsPf+ZeSgSgstLoyd5vkk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rJ622DgdHp397tFU4kScJ6jlVv6yAfVs4GjheHZGjX1+Z803ZxkK9Lnmn4bKRxQCUApixzEWw1TkLl4pCc5BLe225ZHwnNDQErO3wFjOrtka7xtBpAXoCkOKHWUSQ/sw/ywjoT92zjZr3fhHcMeGFwbSlOQeQH+aFojmhK/bk3Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=WfSW45u0; arc=none smtp.client-ip=95.215.58.185
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="WfSW45u0"
Date: Wed, 6 Nov 2024 14:34:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1730921666;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=AjMMpluojta2AuzxRhbwiOblCVhsItOypqbCCSmEo7M=;
	b=WfSW45u0ctCKuvHvNM4QJH1AvV8BqEknVj94YpciQo2+UDotwqitjJsKPUTLFoqL9vDVcT
	2FR7cVgs4+XfQvp9S7ruk/u4ThSdnVq4fqpq+FrYQP6dTbZlP0lgDkgokB4oeLWeP8Y4kC
	jzc0fRqSzGZL2KmCF4vy3qVMT0Eazmo=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Piotr Zalewski <pZ010001011111@proton.me>
Cc: linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	skhan@linuxfoundation.org, syzbot+bee87a0c3291c06aa8c6@syzkaller.appspotmail.com
Subject: Re: [PATCH] Fix wrong max check in bch2_opt_validate
Message-ID: <zfmodm3fg572yt3ef5zuf3dzc23234d5nrmtiuyxjquki2756w@yyt2fekeyfnr>
References: <20241031231823.688918-2-pZ010001011111@proton.me>
 <pkxqQnSTQLReyYEHegx90LNp5dbR6LlpcqUIkBFa2CiL-0P48QWpGJ1YYKtWwu0IFM7H-2T4fYQz0MldP6OqZppPzmqafQDKouhETLnM5o4=@proton.me>
 <v5wttxaimwpqb5jfpxvcs3rmg27fm4mf7446slutl7ztha6q4p@434ppx3gzv7l>
 <QYWUohk8PTK2Z_y-IZBUFDFqM6BNsqv4oS95yfOP5DGWuvCNyvC6R1bizXEubPYtqm2ZpRWNN4BH9__biGJ5Ti3Yh88Ge_9HCSSAdyU1MxA=@proton.me>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <QYWUohk8PTK2Z_y-IZBUFDFqM6BNsqv4oS95yfOP5DGWuvCNyvC6R1bizXEubPYtqm2ZpRWNN4BH9__biGJ5Ti3Yh88Ge_9HCSSAdyU1MxA=@proton.me>
X-Migadu-Flow: FLOW_OUT

On Wed, Nov 06, 2024 at 06:58:04PM +0000, Piotr Zalewski wrote:
> 
> 
> 
> 
> 
> Sent with Proton Mail secure email.
> 
> On Wednesday, November 6th, 2024 at 6:52 PM, Kent Overstreet <kent.overstreet@linux.dev> wrote:
> 
> > On Wed, Nov 06, 2024 at 08:11:13AM +0000, Piotr Zalewski wrote:
> > 
> > > Hi Kent,
> > > 
> > > Did you see this?
> > 
> > 
> > Whoops, I did miss it the first time.
> 
> np
> 
> > I think it'd be better to fix it in the OPT_STR() macro though.
> 
> If changed in OPT_STR() macro it would also require a change in
> bch2_opt_to_text:434 (it also does -1 there).

*nod*

I think we should do it that way then, we don't want opt->max meaning
different things in different contexts if we can avoid it
