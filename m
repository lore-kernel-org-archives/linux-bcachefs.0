Received: from server.roznica.com.ua (server.roznica.com.ua [80.90.224.56])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8D5D458222
	for <linux-bcachefs@vger.kernel.org>; Tue,  5 Mar 2024 12:43:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=80.90.224.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709642617; cv=none; b=YTKpUqwMf0HLA4bVJkULBiaKc73E/J3hPRY6MjDF8sCJ9zIBX9TRKMvNydPHswb8wmDSCt/Rab6+wkgK9Wj2hApt9u0OBIQ/iyK/GRrIpoB3xUmeMKZOEIHqndnfJRsFL47cUCoBqOEqGHWlv1pji1CWMVnnHOW1wWSjizO15qo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709642617; c=relaxed/simple;
	bh=eNue71nLbQfoKkzfIR1dOjAmjY2BLRTFl0E+CYDYE3g=;
	h=Subject:To:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=MI5wRaUAWuAzWpP969tu6iXux2lQQ4Pacfe4r3w7JKsC6yECWuVNdBQ41neR+bQ1TyGWnekgh6BZ6e3Scy6RRKTdyvE6InSq4kskKU3fXEDtx0s0O4qFmqCsl7u2SjSmXD/0141kJMaUxciDzOFCkv/UnGoGTuwVRPsC8OgKPQs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roznica.com.ua; spf=pass smtp.mailfrom=roznica.com.ua; arc=none smtp.client-ip=80.90.224.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roznica.com.ua
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=roznica.com.ua
Received: from work.roznica.com.ua (188-115-141-236.broadband.tenet.odessa.ua [188.115.141.236])
	by server.roznica.com.ua (Postfix) with ESMTP id B2049986FDE
	for <linux-bcachefs@vger.kernel.org>; Tue,  5 Mar 2024 14:33:33 +0200 (EET)
Subject: Re: [WIP] bcachefs fs usage update
To: linux-bcachefs@vger.kernel.org
References: <gajhq3iyluwmr44ee2fzacfpgpxmr2jurwqg6aeiab4lfila3p@b3l7bywr3yed>
From: Michael <mclaud@roznica.com.ua>
Message-ID: <d243882b-7bdd-e743-85ab-00b104befb3f@roznica.com.ua>
Date: Tue, 5 Mar 2024 14:33:33 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <gajhq3iyluwmr44ee2fzacfpgpxmr2jurwqg6aeiab4lfila3p@b3l7bywr3yed>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit

On 2024-03-02 04:14, Kent Overstreet wrote:
> I'm currently updating the 'bcachefs fs usage' command for the disk
> accounting rewrite, and looking for suggestions on any improements we
> could make - ways to present the output that would be clearer and more
> useful, possibly ideas on on new things to count...
> 
> I think a shorter form of the per-device section is in order, a table
> with data type on the x axis and the device on the y axis; we also want
> percentages.
> 
> The big thing I'm trying to figure out is how to present the snapshots
> counters in a useful way.
> 
> Snapshot IDs form trees, where subvolumes correspond to leaf nodes in
> snapshot trees and interior nodes represent data shared between multiple
> subvolumes.
> 
> That means it's straightforward to print how much data each subvolumme
> is using directly - look up the subvolume for a given snapshot ID, look
> up the filesystem path of that subvolume - but I haven't come up with a
> good way of presenting how data is shared; these trees can be
> arbitrarily large.
> 
> Thoughts?
> 

Short/long form human readable and something similar to json
Short form Size, Used, Free

> Filesystem: 77d3a40d-58b6-46c9-a4d2-e59c8681e152
> Size:                       11.0 GiB
> Used:                       4.96 GiB
> Online reserved:                 0 B
> Inodes:                            4
> 
> Persistent reservations:
> 2x                          5.00 MiB
> 

Option for show layout, warning if layout not optimal

> Data type       Required/total  Durability    Devices
> btree:          1/2             2             [vdb vdc]           14.0 MiB
> btree:          1/2             2             [vdb vdd]           17.8 MiB
> btree:          1/2             2             [vdc vdd]           14.3 MiB
> user:           1/2             2             [vdb vdc]           1.64 GiB
> user:           1/2             2             [vdb vdd]           1.63 GiB
> user:           1/2             2             [vdc vdd]           1.64 GiB
> 

Option for detailed

> Compression:      compressed    uncompressed     average extent size
> lz4                 4.63 GiB        6.57 GiB                 112 KiB
> incompressible       328 MiB         328 MiB                 113 Ki >

> Snapshots:
> 4294967295          4.91 GiB
Per snapshot/subvol all/mask info like Total, Exclusive, Short layout 
(replicas-size, EC-size)
> 
> Btrees:
> extents             12.0 MiB
> inodes               256 KiB
> dirents              256 KiB
> alloc               10.8 MiB
> subvolumes           256 KiB
> snapshots            256 KiB
> lru                  256 KiB
> freespace            256 KiB
> need_discard         256 KiB
> backpointers        20.5 MiB
> bucket_gens          256 KiB
> snapshot_trees       256 KiB
> logged_ops           256 KiB
> accounting           256 KiB
> 
May be device label or device name from /dev/mapper/... Not dm-0, dm-1, etc
> (no label) (device 0):           vdb              rw
>                                  data         buckets    fragmented
>    free:                     2.27 GiB           18627
>    sb:                       3.00 MiB              25       124 KiB
>    journal:                  32.0 MiB             256
>    btree:                    15.9 MiB             127
>    user:                     1.64 GiB           13733      41.1 MiB
>    cached:                        0 B               0
>    parity:                        0 B               0
>    stripe:                        0 B               0
>    need_gc_gens:                  0 B               0
>    need_discard:                  0 B               0
>    capacity:                 4.00 GiB           32768
> 
> (no label) (device 1):           vdc              rw
>                                  data         buckets    fragmented
>    free:                     2.28 GiB           18652
>    sb:                       3.00 MiB              25       124 KiB
>    journal:                  32.0 MiB             256
>    btree:                    14.1 MiB             113
>    user:                     1.64 GiB           13722      38.5 MiB
>    cached:                        0 B               0
>    parity:                        0 B               0
>    stripe:                        0 B               0
>    need_gc_gens:                  0 B               0
>    need_discard:                  0 B               0
>    capacity:                 4.00 GiB           32768
> 
> (no label) (device 2):           vdd              rw
>                                  data         buckets    fragmented
>    free:                     2.28 GiB           18640
>    sb:                       3.00 MiB              25       124 KiB
>    journal:                  32.0 MiB             256
>    btree:                    16.0 MiB             128
>    user:                     1.64 GiB           13719      38.6 MiB
>    cached:                        0 B               0
>    parity:                        0 B               0
>    stripe:                        0 B               0
>    need_gc_gens:                  0 B               0
>    need_discard:                  0 B               0
>    capacity:                 4.00 GiB           32768
> 

And option for full info ))

-- 
Michael
