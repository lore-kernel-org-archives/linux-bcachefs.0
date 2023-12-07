Received: from mx3.molgen.mpg.de (mx3.molgen.mpg.de [141.14.17.11])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC4BFAA
	for <linux-bcachefs@vger.kernel.org>; Thu,  7 Dec 2023 03:53:21 -0800 (PST)
Received: from [141.14.31.7] (theinternet.molgen.mpg.de [141.14.31.7])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: buczek)
	by mx.molgen.mpg.de (Postfix) with ESMTPSA id DA8C461E5FE05;
	Thu,  7 Dec 2023 12:53:06 +0100 (CET)
Message-ID: <97375d00-4bf7-4c4f-96ec-47f4078abb3d@molgen.mpg.de>
Date: Thu, 7 Dec 2023 12:53:06 +0100
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: How to cope with subvolumes and snapshots on muti-user systems?
Content-Language: en-US
To: NeilBrown <neilb@suse.de>
Cc: Kent Overstreet <kent.overstreet@linux.dev>,
 linux-bcachefs@vger.kernel.org, Stefan Krueger <stefan.krueger@aei.mpg.de>
References: <3222cf4b-8f9d-4576-b2e2-c78e5655f4dc@molgen.mpg.de>
 <20231129214328.efbfpl3javifvwk5@moria.home.lan>
 <63ca9346-6bec-40d5-8f7e-4181721652f1@molgen.mpg.de>
 <20231130073948.v3jkmmvtwnefwvq3@moria.home.lan>
 <170137665630.7109.15666373159604652834@noble.neil.brown.name>
 <3b2720ca-23eb-4666-b04f-5bff4b1ac1cf@molgen.mpg.de>
 <170172993746.7109.10813288295717935377@noble.neil.brown.name>
 <12f711f9-70a2-408e-8588-2839e599b668@molgen.mpg.de>
 <170181366042.7109.5045075782421670339@noble.neil.brown.name>
From: Donald Buczek <buczek@molgen.mpg.de>
In-Reply-To: <170181366042.7109.5045075782421670339@noble.neil.brown.name>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 12/5/23 23:01, NeilBrown wrote:
> On Wed, 06 Dec 2023, Donald Buczek wrote:
>
>> statx() would be very nice, because you can avoid additional system
>> calls.  I wish, we could get the file_handle in the same call, but I
>> assume that is not possible to be added to statx() because of the
>> potential big and unknown length.  However, I assume the combination
>> of volume-ident and inode number, which both would be available from
>> one statx() call, are also unique, so this should do, too. 
> 

> The file handle is limited in size to 128 bytes.  The current statx
> structure doesn't have that much spare space, but I don't see a problem
> with having it return a larger structure if that is explicitly
> requested.  Of course I don't know what other developers might think of
> that.
> 
> Extending statx to return a "root-of-subvol" flag or possibly a
> "subvol-id" u64 should be uncontroversial and would allow backup tools
> and similar to easily ignore subvols.  This would need to be driven the
> the bcachefs team of course.

I'd vote for the subvol-id. I think, with bcachefs a u32 would do, but it could be return as u64 for future growth or other filesystems.

128 additional bytes for the space for (any) filehandle seems like a lot. And it is more than the current 96 bytes reserve of `struct statx`. I don't know if a user-provided pointer field (optional, to another 128 bytes user buffer) would be considerable at all.

It's not really needed for bcachefs (its file_handle is just 16 byte anyway: u64 inode, u32 volume, u32 generation) or for my usecase (don't blindly walk into snapshots). But other tools might profit from the ability to get any file_handle with statx(), e.g. userspace nfs server, software with some an external file registration database.

Best
  Donald

> 
> Thanks,
> NeilBrown

-- 
Donald Buczek
buczek@molgen.mpg.de
Tel: +49 30 8413 1433

