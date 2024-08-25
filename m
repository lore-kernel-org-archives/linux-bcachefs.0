Received: from out-184.mta0.migadu.com (out-184.mta0.migadu.com [91.218.175.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 760153B78D
	for <linux-bcachefs@vger.kernel.org>; Sun, 25 Aug 2024 23:15:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724627740; cv=none; b=QxTlxlrbiG2p87rYrs6pefyI533n/KqRPE3QIsbujSeBXhzUntVjqHHvc+263eYrQ49J53mJ5/ZPInWYSkUKJV6CEFGTH0OWZC0YlLnCvW4tngN+AxItFkGeigiYV7xXWhsHOIL/8gAlDIPBEqjHMCmc2sTt3P3EHrDhlKYQsJA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724627740; c=relaxed/simple;
	bh=wkdCUQtZAAJn1WOZeW+h1ed+flXOdZxdw9ge6oP+g8A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OGheYBp7QnzVzb2cEWQPqZeV1nA2QWOo+phpAKZC+PGpLQBkTgCuor6PNmSP7BZDZiw/e0/cz514/wLApnJPFn3DjqOteDolDepZ4RoVYn3ZwF4TEwXyEqZv2d+ugOxRjTcqhT+g5bsbS0LoquYosYHc3aXyzt7afSCjgukGf9A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=UX3f6rCV; arc=none smtp.client-ip=91.218.175.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="UX3f6rCV"
Date: Sun, 25 Aug 2024 19:15:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1724627736;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=L/PoZpPqS/s7Yg5HYF/cFLzcMfwRwTedQTVO5RuCotk=;
	b=UX3f6rCVOE1FrPRWMrhdCGNFaHS38OdV20H9e/ni9aAEXcYu0LquYhf4shrWJ/388gPlQ4
	L/Pl9J3Wwil2ZZpb6AqLOw2k9KY97V8hhdU2+EAwhO5zqO1neKpv+KYMoAc3ByUNqn4ILq
	C8+5rs10zQM+fc+gLnLgThEQKIlhc8g=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Thorsten Blum <thorsten.blum@toblux.com>
Cc: Kees Cook <kees@kernel.org>, 
	"Gustavo A. R. Silva" <gustavoars@kernel.org>, linux-bcachefs@vger.kernel.org, 
	LKML <linux-kernel@vger.kernel.org>, linux-hardening@vger.kernel.org
Subject: Re: [PATCH] bcachefs: Annotate bch_replicas_entry_{v0,v1} with
 __counted_by()
Message-ID: <mr6kpl4zyqqalahxc7s574kc3xemlzfvp423z57yzt6j2nddcj@dx75kkxhi4ch>
References: <20240825133601.24036-2-thorsten.blum@toblux.com>
 <cqyrlfpjprkwdteljmtcnl3z2etzitvodrlv7v57tuizvklpcx@gg7dbstowwd6>
 <4911B345-A37E-4FB9-9339-83029033EE4D@toblux.com>
 <b7eqkyfv4nvxlserwuknw73y4c4n25b2i36xfsn4cfhjg4yc2n@oawo2z4ye6lo>
 <6B15FD73-8FD5-4180-9190-FA8ABF7E88BB@toblux.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6B15FD73-8FD5-4180-9190-FA8ABF7E88BB@toblux.com>
X-Migadu-Flow: FLOW_OUT

On Mon, Aug 26, 2024 at 01:08:29AM GMT, Thorsten Blum wrote:
> On 26. Aug 2024, at 00:56, Kent Overstreet <kent.overstreet@linux.dev> wrote:
> > On Sun, Aug 25, 2024 at 10:41:55PM GMT, Thorsten Blum wrote:
> >> On 25. Aug 2024, at 20:43, Kent Overstreet <kent.overstreet@linux.dev> wrote:
> >>> On Sun, Aug 25, 2024 at 03:36:02PM GMT, Thorsten Blum wrote:
> >>>> Add the __counted_by compiler attribute to the flexible array members
> >>>> devs to improve access bounds-checking via CONFIG_UBSAN_BOUNDS and
> >>>> CONFIG_FORTIFY_SOURCE.
> >>>> 
> >>>> Increment nr_devs before adding a new device to the devs array and
> >>>> adjust the array indexes accordingly.
> >>> 
> >>> The nr_devs changes are pretty gross - please add a helper for that
> >> 
> >> How about a macro in replicas_format.h like this:
> >> 
> >> #define replicas_entry_add_dev(e, d) ({
> >> 	(e)->nr_devs++;
> >> 	(e)->devs[(e)->nr_devs - 1] = (d);
> >> })
> > 
> > Does it need to be a macro?
> 
> It could also be two functions, one for each struct.
> 
> Which one do you prefer?

I suppose the macro fits with what we're doing for
replicas_entry_bytes() - that's alright then
