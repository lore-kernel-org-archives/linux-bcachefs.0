Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 663344C9D;
	Sat,  7 Jun 2025 08:36:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749285394; cv=none; b=O9VmtVPgsWQCtgmOx7/D7gXmr3uQKqorzFyJTCd9u8anK60ZAHXVQBOTI0wZMzl7ydVPJDWD55E242oMuBvk9CwVDUFdX7MQczrei7woSXCL/TzP3ivj2S+26ymcCjEsf57XMktWETcJTruHXdy5P5YOob9yjcgMeJzOMTPJoF4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749285394; c=relaxed/simple;
	bh=Hu8VVLCEYhC7Sr+6aOY/Va6q1UuSqZeFSg2cyvpifKg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=O/vOvXy4ESZ4aGPJX0dSiCL4ZUBuGUzWprQJg9s2T6gOL+dxEFq8+eM3Ll8PNr8ac2FfbXTsg6BMWTAi5YVM+484de5S0hJq0cvBrqLe8y+Xy/Dg819Dp3zZB5fYVQlkL9yD8O6mnHVjazEfuU2CFGza75/ClptJT+4O2MrxJVA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vEw6mKDU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vEw6mKDU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5A85C4CEED;
	Sat,  7 Jun 2025 08:36:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1749285394;
	bh=Hu8VVLCEYhC7Sr+6aOY/Va6q1UuSqZeFSg2cyvpifKg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=vEw6mKDU+iK+6rzrYl9OAiMbPcKZ0u+5kjFJVEt2e0D1MOp8PoYiRTyrXpNs+s8xq
	 6+gm/0f323EA7c9Ma6ndj4W4Frf7PHHw3KAWLHGhYvkDHxIilH08zTD9oSaxKmx+sp
	 UdSeRAgrKAnzfNNWOBibcfzhVrQ9MHSytm5qwu7g=
Date: Sat, 7 Jun 2025 10:36:31 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: linux-bcachefs@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [GIT PULL] bcachefs fixes for 6.15 stable
Message-ID: <2025060721-retaining-thursday-471c@gregkh>
References: <xlnudv42ksgzhydnz4uefmiuh4f6ebtixwwjh2mwj5fivw24ll@tczlx6fmsu5k>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <xlnudv42ksgzhydnz4uefmiuh4f6ebtixwwjh2mwj5fivw24ll@tczlx6fmsu5k>

On Thu, Jun 05, 2025 at 03:31:14PM -0400, Kent Overstreet wrote:
> The following changes since commit 3ef49626da6dd67013fc2cf0a4e4c9e158bb59f7:
> 
>   Linux 6.15.1 (2025-06-04 14:46:27 +0200)
> 
> are available in the Git repository at:
> 
>   git://evilpiepirate.org/bcachefs.git tags/bcachefs-for-6.15-2025-06-05
> 
> for you to fetch changes up to fc9459c9a888766c4c4adff59b072aad1bfbf6ad:
> 
>   bcachefs: Fix subvol to missing root repair (2025-06-05 14:04:58 -0400)

Now queued up, thanks!

greg k-h
