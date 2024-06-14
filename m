Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF541EAF0;
	Fri, 14 Jun 2024 14:36:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718375791; cv=none; b=r5oxJQB0/DHu+xN6Lv/JLm2yzbX4MNPCJYIMEryXmjDe8802DVpQ2f898Q0tP2Q6iJ6dxvJv5lv5BpAcfCExsyJ/eCNSf5bWqs0vcHrCHr77n3t3PjHpsDb8KzF0OG8SboU9THsSbG5RwP2a90pcGEBNVIQ4qtlCE+O8hhab2CE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718375791; c=relaxed/simple;
	bh=Zoj/dT5eLtnE7XO/yRCaT4Lj+WnWxVs4b53STnf+ekA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NoKsmXgCtY+6oE64/8SUjokzBDBYOLgkOq1S0K9HOe0aswvzoMHKDs7/qqhOpxqEhACcspzrYgU9ROBBY7rsBqy6k9cDLELGiPuoOhYO8yPBHsg2JIOtZqkX9BowLQXQxQt7sWDCWxMlx7uCDFZ/HZWQbhkvgpNIXdDSzSLO11U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=H6zHWbY/; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="H6zHWbY/"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=7dHUp5GqMpdx5VQ4GQ47gCY1IaP6VkrhDrYeOSheEP8=; b=H6zHWbY/J/BDpzOz7VvVT4wO0v
	/41ceTTNPqv9ohID07wxX3PTRgT6tiRnqy5QgHoFIdo7LxrDLpnquPOCjbvRnEomg4HD+qdZDWyXw
	gTG16BO7IsbA31BrOSOl4jCqFlnFXfyW9XuGu6+tH2brQ1534LGOKHxd65iDSBr7yB/3uLLghoDfi
	iGMN36MHzNC+CDKAsPkTzqwwajpLgQqOsh6+/BQ7gWSw6C0iR3ir7Txg6EGYqTZJXkZqB5CO2yh+w
	aI4FXEShy/KLeYnd8/m3XT7Jbwec7KaZ94jlEczMfuXR+LFSseNtIOm/Gh09FEFFGA4hE1MP5zrVJ
	YRMzrD8Q==;
Received: from willy by casper.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sI82Q-0000000H3Eu-3YK4;
	Fri, 14 Jun 2024 14:36:23 +0000
Date: Fri, 14 Jun 2024 15:36:22 +0100
From: Matthew Wilcox <willy@infradead.org>
To: "Pankaj Raghav (Samsung)" <kernel@pankajraghav.com>
Cc: Brian Foster <bfoster@redhat.com>,
	Kent Overstreet <kent.overstreet@linux.dev>,
	linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org,
	Pankaj Raghav <p.raghav@samsung.com>
Subject: Re: [PATCH 1/2] bcachefs: use FGP_WRITEBEGIN instead of combining
 individual flags
Message-ID: <ZmxVZiveDdzyByTQ@casper.infradead.org>
References: <20240614105031.57032-1-kernel@pankajraghav.com>
 <20240614105031.57032-2-kernel@pankajraghav.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240614105031.57032-2-kernel@pankajraghav.com>

On Fri, Jun 14, 2024 at 10:50:30AM +0000, Pankaj Raghav (Samsung) wrote:
>  	ret = bch2_filemap_get_contig_folios_d(mapping, pos, end,
> -				   FGP_LOCK|FGP_WRITE|FGP_STABLE|FGP_CREAT,
> -				   mapping_gfp_mask(mapping),
> -				   &fs);
> +					       FGP_WRITEBEGIN,
> +					       mapping_gfp_mask(mapping), &fs);

Don't change the indentation here.  In the next patch it makes the
lines too long.

In general, don't change the indentation.  It's been one of the biggest
pains of the folio conversion.  "Oh, you changed the name of this
function and now the arguments don't line up".  Don't line up the
arguments with the opening paren.
