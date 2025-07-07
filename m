Received: from out-181.mta0.migadu.com (out-181.mta0.migadu.com [91.218.175.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A1B11F4168
	for <linux-bcachefs@vger.kernel.org>; Mon,  7 Jul 2025 22:22:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751926976; cv=none; b=m4IQtgSMjv+JIBkR9d0Sh+sNSfl1tdeYF0m64QAU1LITZcx+15q9EZJJlCqQHZfLWj2TFJ/LLU7qjRgz5Da2NKBlz97jEMY+T04H7GHrzdkf9IM/XIOVJuAf6dtZTAu4s/PznAygwQ/7j0EY+qz94UPODmm+lScekvkEijpl3LQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751926976; c=relaxed/simple;
	bh=z7GqKAi25bTXPEKDbmE5J6DWx+qv26tJ900xP2qzwE4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=n1zOGl2YsKEj+BdyiDKYMID6QePdDyx24DSiSnPz4m1V8Zl06Nnm5FFhHtf3JZPIyx6EGc+MPImtrRia1mnXbWVLZxy3bxzllPSiIOMh07okSoxEzsL0ByAmvxLRWlKA3qbPfIQ/qYvjEqmVi4UC75Ldj2jpgA5+91souXW6Va8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=ekptQ4l1; arc=none smtp.client-ip=91.218.175.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="ekptQ4l1"
Date: Mon, 7 Jul 2025 18:22:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1751926972;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=z7GqKAi25bTXPEKDbmE5J6DWx+qv26tJ900xP2qzwE4=;
	b=ekptQ4l1j5fA3nJX0FfzQuvby0fQrLAFA21Eu/+qJcj2hNxlAVa3gCf7CfpxuUZgTw4Ou1
	keKUNdtsqqZ2SEsSaRip2TjGeYTOz9m0Y2BUZcqdfz8asH+nQ/Vl8C0jgtjRyLIOVBnxCn
	KrcVARWBOvgbDdr/znjJ+vDTo1EmHLo=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: "Carl E. Thompson" <list-bcachefs@carlthompson.net>
Cc: John Stoffel <john@stoffel.org>, linux-bcachefs@vger.kernel.org
Subject: Re: [GIT PULL] bcachefs fixes for 6.16-rc4
Message-ID: <z57jfiaepu5xi5dwxdnei72stfx3nlhwyem6pj24uqtei2jb6o@zfwwiyum6gy6>
References: <ahdf2izzsmggnhlqlojsnqaedlfbhomrxrtwd2accir365aqtt@6q52cm56jmuf>
 <CAHk-=wi+k8E4kWR8c-nREP0+EA4D+=rz5j0Hdk3N6cWgfE03-Q@mail.gmail.com>
 <xl2fyyjk4kjcszcgypirhoyflxojzeyxkzoevvxsmo26mklq7i@jw2ou76lh2py>
 <26723.62463.967566.748222@quad.stoffel.home>
 <gq2c4qlivewr2j5tp6cubfouvr42jww4ilhx3l55cxmbeotejk@emoy2z2ztmi2>
 <26732.10255.420410.321937@quad.stoffel.home>
 <1228142592.130.1751923921340@mail.carlthompson.net>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1228142592.130.1751923921340@mail.carlthompson.net>
X-Migadu-Flow: FLOW_OUT

On Mon, Jul 07, 2025 at 02:32:01PM -0700, Carl E. Thompson wrote:
> Don't bother. You can't reason with him and you can't "fix" him. He'll
> keeping sucking up as much of our collective time and energy as we
> allow so it's time to move on and stop feeding him.

There's an awful lot of people who claim to know my job better than I
do.

I'm terribly sorry I can't make you all happy :)
