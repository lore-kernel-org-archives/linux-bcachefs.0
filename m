Received: from out-173.mta1.migadu.com (out-173.mta1.migadu.com [95.215.58.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBC5722ACFB
	for <linux-bcachefs@vger.kernel.org>; Mon, 10 Mar 2025 13:49:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741614579; cv=none; b=eTpkNaFpGVOn0g3AQNMbwAi7txCWD13iX3exF6RuPtucs0e6CC7tUzPNAbndLBMsTEIWMm1tOeY5ejDoTbG1+EMdidzunYgub1my7KwrbjL6g1V+ykZXuuW6qMn3y6GK2bMCvALPZrsRFeXRes2ovm38J3MKzL6y0whVs1sbjXk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741614579; c=relaxed/simple;
	bh=/+jV31PTgw6aqTRc8C6RU/6dvmmCJ1MpYAbbhnWUjPw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jiD/98kIMawNZI+vqrf/+S0i/oeY8uhRyGqWZF+n6kI01l68aZZpCw1bUiONzl6F27ZUWXceQrne+OWfr1dnLrgCrdHG+KODPI3SrY48C0zQcI13V+vZ9LfmYwMW5/2Du954xEzb3dKNKO/8/8auPSGBu1zaL5n/gmaub5KiFGs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=ibhBt64B; arc=none smtp.client-ip=95.215.58.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="ibhBt64B"
Date: Mon, 10 Mar 2025 09:49:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1741614561;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=p/YTv0hHn4G4Scu3ATutypohlkwvEToRHT1q3tOxv1M=;
	b=ibhBt64Bnx5dGjlh8qWaTtLQT4Lz408q33Aqcf4PYL8ztkoC3S5CZA7zWXODC5KvXuXmdT
	9acI5JMEQsAOzU2TBViyk45087/40QkzGXrXFWLUTTKl/CyuWlEbTO+qe0fe9/nFuycmqC
	rCRruIPipMxWkv0xrWwzHq0RQ2u3N/s=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: =?utf-8?Q?Micka=C3=ABl_Sala=C3=BCn?= <mic@digikod.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, cve@kernel.org, 
	=?utf-8?Q?G=C3=BCnther?= Noack <gnoack@google.com>, linux-security-module@vger.kernel.org, 
	Dave Chinner <david@fromorbit.com>, linux-bcachefs@vger.kernel.org
Subject: Re: CVE-2025-21830: landlock: Handle weird files
Message-ID: <k7toamo7fd647262axepi5qut2axylrx4rew66jdlw5wmyog3h@3ivphkt2xkxr>
References: <2025030611-CVE-2025-21830-da64@gregkh>
 <20250310.ooshu9Cha2oo@digikod.net>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250310.ooshu9Cha2oo@digikod.net>
X-Migadu-Flow: FLOW_OUT

On Mon, Mar 10, 2025 at 01:00:50PM +0100, Mickaël Salaün wrote:
> Hi Greg,
> 
> FYI, I don't think this patch fixes a security issue.  If attackers can
> corrupt a filesystem, then they should already be able to harm the whole
> system.
> 
> The commit description might be a bit confusing, but from an access
> control point of view, the filesystem on which we spotted this issue
> (bcachefs) does not allow to open weird files (but they are still
> visible, hence this patch) and I guess it would be the same for other
> filesystems, right?  I'm not sure how a weird file could be used by user
> space.  See
> https://lore.kernel.org/all/Zpc46HEacI%2Fwd7Rg@dread.disaster.area/
> 
> The goal of this fix was mainly to not warn about a bcachefs issue (and
> avoid related syzkaller report for Landlock), and to harden Landlock in
> case other filesystems have this kind of bug.

Agreed - why was a CVE assigned?
