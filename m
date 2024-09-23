Received: from out-186.mta0.migadu.com (out-186.mta0.migadu.com [91.218.175.186])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37C1FF9D4
	for <linux-bcachefs@vger.kernel.org>; Mon, 23 Sep 2024 21:47:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.186
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727128063; cv=none; b=qcFo/1XmZsPqzaglrz5goy8LuL7anxpu9rZMjx+Ij1RioNTmgVg3ELz5hl7xtiNVlaaogcunu5iwGpLNkFQgud0d+Jw8MnFqekFZPc+v19BJ49thzR5UlOUCc99d3LAGRBEUwDStwh9sqwXV82vnIVOdwUh7uB3rgX5oCy5kSyI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727128063; c=relaxed/simple;
	bh=zxTaVKENhPJI7N7c40d3YaU/flo2B27+Y3TVIxgx7zY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=A8WuSdU3j9ckITOCrl6j2bgnRxmWUZFvXfX/CqyHm6dszAJfwU+vk59dkYKmp9NDjKjbs0rj+LqSeCQ9rUSE4BXLwN5kWEQGBF45I2ImCCQ+xGXMooUvxsgjlhb/W9UuGJTiApvZLQz+mQsrafFB+dfC/wyHEOgBvHG+Az2oq2Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=QsDhEk4W; arc=none smtp.client-ip=91.218.175.186
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="QsDhEk4W"
Date: Mon, 23 Sep 2024 17:47:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1727128060;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=X5crOLV50+FOau9JbBcyaPlO6pi7zIJl1P1gL9ee/Xo=;
	b=QsDhEk4WHLy1FBgJ02jTgo9NaIwF+Z7VR3wFTIQMPORJm8UldRxx73QJhcG7i0pVCukABo
	6el2pTmjEe0mNWXQ1T/ZBRsoFyd7RozhOAgmID+KM0VuGCJEOogAczToxKtOwbdNx5PUK+
	klkiN4FpSE7UKInFHxewU9SUdFXMa8M=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Thorsten Blum <thorsten.blum@linux.dev>
Cc: Thorsten Blum <thorsten.blum@toblux.com>, 
	Hongbo Li <lihongbo22@huawei.com>, linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RESEND PATCH] bcachefs: Remove duplicate included headers
Message-ID: <bsiwbsyxdfiq5cbyzaptcwzobxdu75u7uy642djem6tjddvk5d@6ylscc3jx3lj>
References: <20240923142028.232365-3-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240923142028.232365-3-thorsten.blum@linux.dev>
X-Migadu-Flow: FLOW_OUT

On Mon, Sep 23, 2024 at 04:20:29PM GMT, Thorsten Blum wrote:
> From: Thorsten Blum <thorsten.blum@toblux.com>
> 
> The header files dirent_format.h and disk_groups_format.h are included
> twice. Remove the redundant includes and the following warnings reported
> by make includecheck:
> 
>   disk_groups_format.h is included more than once
>   dirent_format.h is included more than once
> 
> Reviewed-by: Hongbo Li <lihongbo22@huawei.com>
> Signed-off-by: Thorsten Blum <thorsten.blum@toblux.com>

Applied
