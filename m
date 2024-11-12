Received: from out-180.mta0.migadu.com (out-180.mta0.migadu.com [91.218.175.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEA0121A4A4
	for <linux-bcachefs@vger.kernel.org>; Tue, 12 Nov 2024 21:26:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731446802; cv=none; b=q/UKeJmdOdVR8vCvrUhJjavUa+qpsBJpx1z1cRoNIc5z+bhd579O6ToAEsJvZqAgZ0zAH0AkNbalCVkK+tdhggFnLvEvtibTDPDuUVekq7iOMjXnXB+OJb7RL9by+A85FGZTHqIzbeMlgyAyQ9c+Xm/vJRVzSefuwyVUMLLEYFc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731446802; c=relaxed/simple;
	bh=aNXsUqPfFdCo0DwJ0IHzOF0dGjke1mLeLetZqkYIxm8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hAoI0ZYbmkZwYWGN4WYjQFhcJYRX6hT98UHnVeqeli7FpDMGTmVSKoi01A5cxAfA1gFLgQZERxlPJKYRJZ2X5Bqucv86Z8OTchqPhHHTfgQBpyb/OO7wyPRE//lYMaRNTMgLvyz37M0PNBGyyIS4QfTftCtgByzHM0Qp/NFm6BU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Ep/m6M/N; arc=none smtp.client-ip=91.218.175.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Ep/m6M/N"
Date: Tue, 12 Nov 2024 16:26:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1731446797;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ZoIX9QjWiY/Twc1VIV2f4gxZzMonFlanTHh7Z622eGY=;
	b=Ep/m6M/NENT8NfWSD3b4YuMHkDNjELRN+ip63mk/spByGy4fDDmQqh75z9FXEk0QBsGMEq
	bvgjlIHwxMYNRQXCRuOFnoAuL6jry04uMbAijK3vJ7ndb/IZtO6JctrDJ18kBqQp7/HZHy
	Sh/ha9BTG+s+gM20510CGihO7LcL2TE=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Hongbo Li <lihongbo22@huawei.com>
Cc: linux-bcachefs@vger.kernel.org
Subject: Re: [PATCH] bcachefs: bch2_inum_to_path()
Message-ID: <3fauv3t52lqprhrnjtihhgll46rwh7qlwuivfwlney6chkdxjq@awrncdkwpkmn>
References: <20241112021404.86597-1-kent.overstreet@linux.dev>
 <cac8f1ed-8d7c-45cd-9e67-5d3afae43df4@huawei.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cac8f1ed-8d7c-45cd-9e67-5d3afae43df4@huawei.com>
X-Migadu-Flow: FLOW_OUT

On Tue, Nov 12, 2024 at 10:55:39PM +0800, Hongbo Li wrote:
> On 2024/11/12 10:14, Kent Overstreet wrote:
> > +		unsigned orig_pos2 = path->pos;
> > +		prt_bytes(path, dirent_name.name, dirent_name.len);
> > +		reverse_bytes(path->buf + orig_pos2, path->pos - orig_pos2);
> These two line can be replaced with prt_bytes_reversed helper.

yup

> > +
> > +		prt_char(path, '/');
> > +
> > +		if (d.v->d_type == DT_SUBVOL)
> > +			inum.subvol = le32_to_cpu(d.v->d_parent_subvol);
> > +		inum.inum = d.k->p.inode;
> > +
> > +		bch2_trans_iter_exit(trans, &d_iter);
> > +	}
> > +
> > +	if (!path->pos)
> The condition should be if (orig_pos == path->) ?

good catch, that was from an earlier version of the patch
